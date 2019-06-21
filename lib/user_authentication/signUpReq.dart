import 'package:experto/user_authentication/userData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:experto/utils/bloc/is_loading.dart";
import 'package:experto/global_data.dart';

class Authenticate {
  CollectionReference userReference;
  AuthException exception;
  List<String> details;
  Future<void> Function(BuildContext context) fn;
  String msg;
  Data userData;

  Authenticate() {
    //_isSignIn = false;
    userData=new Data();
    details = new List<String>();
    getUser();
    msg = "Invalid details";
  }

  void clear() {
    details = new List<String>();
    getUser();
    msg = "Invalid details";
    userData.profileData = null;
  }

  Future<bool> isSignIn(context) async {
    userData.profileData = await FirebaseAuth.instance.currentUser();
    print(userData.profileData.toString());
    try {
      if (userData.profileData == null) {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/user_login');
        return false;
      } else {
        userData.detailsData = await userReference.document(userData.profileData.uid).get();
        if(!userData.detailsData.exists)
          throw("error");
        Navigator.pushNamedAndRemoveUntil(
            context, '/user_home', ModalRoute.withName(':'),
            arguments: userData);

        return true;
      }
    } catch (e) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/user_login');
      return false;
    }
  }

  Future<void> _ackAlert(BuildContext context, String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getUser() async {
    userReference = Firestore.instance.collection("Users");
  }

  getName(String x) => details.add(x);
  getPass(String x) => details.add(x);
  getCity(String x) => details.add(x);
  getMobile(String x) => details.add(x);
  getEmail(String x) => details.add(x);

  Future<void> signUp(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    FormState formState = _formKey.currentState;
    details.clear();
    UserUpdateInfo userUpdateInfo=new UserUpdateInfo();
    if (formState.validate()) {
      formState.save();
      try {
        isLoadingSignup.updateStatus(true);
        //_isSignIn = true;
        QuerySnapshot val = await userReference
            .where("Mobile", isEqualTo: int.parse(details[3]))
            .getDocuments();
        if (val.documents.length != 0) throw ("Mobile Number already in use");
        userData.profileData = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: details[1], password: details[4]);
        currentUser = new Users(
       //   email: details[1],
          city: details[2],
          name: details[0],
          m: details[3],
        );
        userUpdateInfo.displayName=details[0];
        //userUpdateInfo.photoUrl=
        await userData.profileData.updateProfile(userUpdateInfo);
        Firestore.instance.runTransaction((Transaction t) async {
          await userReference.document(userData.profileData.uid).setData(currentUser.toJson());
        });
        userData.profileData=await FirebaseAuth.instance.currentUser();
        userData.detailsData = await userReference.document(userData.profileData.uid).get();
        Navigator.pushNamedAndRemoveUntil(
            context, '/user_home', ModalRoute.withName(':'),
            arguments: userData);
        formState.reset();
      } catch (e) {
        //_isSignIn = false;
        details.clear();
        isLoadingSignup.updateStatus(false);
        _ackAlert(
            context,
            "SignUp Failed!",
            e == "Mobile Number already in use"
                ? e
                : e.toString().split(',')[1]);
      }
    }
  }

  Future<void> signIn(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    details.clear();
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try {
        userData.profileData=await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: details[0], password: details[1]);
        userData.detailsData = await userReference.document(userData.profileData.uid).get();
        print(userData.detailsData);
        print(userData.detailsData.data);
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/user_home',
          ModalRoute.withName(':'),
          arguments: userData,
        );
        formState.reset();
      } catch (e) {
        details.clear();
        isLoadingLogin.updateStatus(false);
        _ackAlert(context, "Login Failed!", e.toString().split(',')[1]);
      }
    }
  }
}

