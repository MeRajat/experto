import 'package:experto/user_authentication/userAdd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:experto/utils/bloc/is_loading.dart";

class InputField extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final bool isPassword;
  final void Function(String) fn;

  InputField(this.hintText, this.fn,
      {this.inputType: TextInputType.text, this.isPassword: false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.only(left: 13, right: 13, top: 13, bottom: 13),
          child: TextFormField(
            obscureText: isPassword,
            validator: (value) {
              if (value.isEmpty) {
                return 'please enter this field';
              }
            },

            onSaved:(input)=>fn(input),
            textInputAction: TextInputAction.next,
            keyboardType: inputType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class Authenticate {
  CollectionReference userReference;
  QuerySnapshot userSnapshot;
  AuthException exception;
  FirebaseUser usr;
  List<String> details;
  bool _isSignIn;
  Future<void> Function(BuildContext context) fn;
  String msg;

  Authenticate() {
    _isSignIn = false;
    details = new List<String>();
    getUser();
    msg="Invalid details";
  }
  void Clear(){
    _isSignIn = false;
    details = new List<String>();
    getUser();
    msg="Invalid details";

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

  Widget signInButton(String x) {
    if (_isSignIn)
      return Center(child: CircularProgressIndicator());
    else
      return Text(
        x,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
  }

  Future<void> signUp(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      formState.save();
      try {
        isLoadingSignup.updateStatus(true);
        _isSignIn = true;
        usr=await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: details[1], password: details[4]);

        user = new Users(
            email: details[1],
            city: details[2],
            name: details[0],
            m: details[3]);
        Firestore.instance.runTransaction((Transaction t) async {
          await userReference.add(user.toJson());
        });
        userSnapshot = await userReference
            .where('emailID', isEqualTo: details[1])
            .getDocuments();
        currentUser=userSnapshot.documents[0];
        Navigator.pushNamedAndRemoveUntil(
            context, '/user_home', ModalRoute.withName(':'));
        formState.reset();
      } catch (e) {
        _isSignIn = false;
        print (e);
        //formState.reset();
        details.clear();
        user=null;
        isLoadingSignup.updateStatus(false);
        _ackAlert(context, "SignUp Failed!", e.toString().split(',')[1]);
      }
    }
  }

  Future<void> signIn(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    details.clear();
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      _isSignIn = true;
      formState.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: details[0], password: details[1]);
        userSnapshot = await userReference
            .where('emailID', isEqualTo: details[0])
            .getDocuments();
        //print(userSnapshot.documents[0]["emailID"]);
        currentUser=userSnapshot.documents[0];
        Navigator.pushNamedAndRemoveUntil(
            context, '/user_home', ModalRoute.withName(':'));
        formState.reset();
      } catch (e) {
        _isSignIn = false;
        formState.reset();
        details.clear();
        isLoadingLogin.updateStatus(false);
        _ackAlert(
            context, "Login Failed!", e.toString().split(',')[1]);
      }
    }
  }
}
