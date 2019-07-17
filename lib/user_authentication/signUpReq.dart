import 'package:experto/user_authentication/userData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:experto/utils/bloc/is_loading.dart";
import 'package:experto/global_data.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:cloud_functions/cloud_functions.dart';

class Authenticate {
  CollectionReference userReference;
  AuthException exception;
  Map<String,dynamic> details;
  Future<void> Function(BuildContext context) fn;
  String msg;
  Data userData;

  Authenticate() {
    //_isSignIn = false;
    userData = new Data();
    details =new Map<String,dynamic> ();
    getUser();
    msg = "Invalid details";
  }

  void clear() {
    details = new Map<String,dynamic>();
    getUser();
    msg = "Invalid details";
    userData.profileData = null;
  }

  void updateConfig() async {
    final pref = await SharedPreferences.getInstance();
    final String key = "account_type";
    pref.setString(key, "user");
  }

  Future<bool> isSignIn(context) async {
    userData.profileData = await FirebaseAuth.instance.currentUser();
    try {
      if (userData.profileData == null) {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/home_page');
        return false;
      } else {
        userData.detailsData =
            await userReference.document(userData.profileData.uid).get();
        if (!userData.detailsData.exists) throw ("error");
        Navigator.pushNamedAndRemoveUntil(
            context, '/user_home', ModalRoute.withName(':'),
            arguments: userData);

        return true;
      }
    } catch (e) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/home_page');
      return false;
    }
  }

  Future<void> _ackAlert(BuildContext context, String title, String content,{bool signup=false,bool forgot=false}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text(forgot?'Yes':'Ok'),
              onPressed: forgot?(){forgotPass(context);}:() {
                if(signup)
                  Navigator.of(context).popUntil(ModalRoute.withName('/user_login'));
                else
                  Navigator.of(context).pop();
              },
            ),
            (title.compareTo("Login Failed!")==0&&!content.contains("Verify"))?
            FlatButton(
              child: Text('Forgot Password'),
              onPressed: () {
                  Navigator.of(context).pop();
                  _ackAlert(context, "Password reset","Do you want to send password reset link to ${details['email']}?",forgot: true);
              },
            ):SizedBox(),
            forgot?FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ):SizedBox(),
          ],
        );
      },
    );
  }

  getUser() async {
    userReference = Firestore.instance.collection("Users");
  }

  getName(String x) => details.addAll({'name':x});
  getPass(String x) => details.addAll({'pass':x});
  getCity(String x) => details.addAll({'city':x});
  getMobile(String x) => details.addAll({'mob':x});
  getEmail(String x) => details.addAll({'email':x});

  Future<void> forgotPass(BuildContext context)async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: details['email']).then((val){
        Navigator.of(context).pop();
        _ackAlert(context, "Reset Success!","Password reset link sent. Reset password and sign in again!");
      });
    }
    catch(e){
      print(e.toString().split(','));
      Navigator.of(context).pop();
      _ackAlert(context, "Reset Failed!",e.toString().split(',')[1]);
    }
  }
  Future<void> signUp(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    FormState formState = _formKey.currentState;
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    if (formState.validate()) {
      formState.save();
      try {
        isLoadingSignup.updateStatus(true);
        //_isSignIn = true;
        QuerySnapshot val = await userReference
            .where("Mobile", isEqualTo: int.parse(details['mob']))
            .getDocuments();
        if (val.documents.length != 0) throw ("Mobile Number already in use");
        userData.profileData = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: details['email'], password: details['pass']);
        userUpdateInfo.displayName = details['name'];
        currentUser = new Users(
          //   email: details[1],
          city: details['city'],
          name: details['name'],
          m: details['mob'],
        );

        //userUpdateInfo.photoUrl=
        await userData.profileData.updateProfile(userUpdateInfo);
        await Firestore.instance.runTransaction((Transaction t) async {
          await userReference
              .document(userData.profileData.uid)
              .setData(currentUser.toJson());
        });
        userData.profileData = await FirebaseAuth.instance.currentUser();
        userData.detailsData =
            await userReference.document(userData.profileData.uid).get();
        updateConfig();
        await userData.profileData.sendEmailVerification();
        await FirebaseAuth.instance.signOut();
        throw("Verify");
      } catch (e) {
        //_isSignIn = false;
        isLoadingSignup.updateStatus(false);
        _ackAlert(
            context,
            e=="Verify"?"Verification Required":"SignUp Failed!",
            e.contains("Mobile")
                ? e:e=="Verify"?"Verify email and then signIn"
                : e.toString().split(',')[1],signup: true);
      }
    }
  }

  Future<void> signIn(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try {
        print(details);
        userData.profileData = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: details['email'], password: details['pass']);
        if(!userData.profileData.isEmailVerified)
        {
          await userData.profileData.sendEmailVerification();
          await FirebaseAuth.instance.signOut();
          throw("Verify");
        }
        userData.detailsData =
            await userReference.document(userData.profileData.uid).get();
        updateConfig();
        HttpsCallable callable= CloudFunctions.instance.getHttpsCallable(functionName: "helloWorld");
        callable.call();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/user_home',
          ModalRoute.withName(':'),
          arguments: userData,
        );
        formState.reset();
      } catch (e) {
        isLoadingLogin.updateStatus(false);
        _ackAlert(context, "Login Failed!",e=="Verify"?"Verify email and then signIn": e.toString().split(',')[1]);
      }
    }
  }
}
