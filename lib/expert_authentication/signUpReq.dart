import 'package:experto/expert_authentication/expertAdd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import "package:experto/utils/bloc/is_loading.dart";

class Authenticate {
  CollectionReference expertReference;
  QuerySnapshot expertSnapshot;
  Map<String,dynamic> details;
  List<DocumentReference> skills;
  String userName;
  //bool _isSignIn;
  Future<void> Function(BuildContext context) fn;

  Authenticate() {
    //_isSignIn = false;
    //details = new List<String>();
    details = {
    "name":"",
    "passowrd":"",
    "email":"",
    "skypeUsername":"",
    "city":"",
    "mobile":'',
    "description":"",
    "workExp":''
  };
    getExpert();
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

  getExpert() async {
    expertReference = Firestore.instance.collection("Experts");
  }

  getName(String x) => details['name']=x;
  getPass(String x) => details['password']=x;
  getCity(String x) => details['city']=x;
  getSkype(String x) => details['skypeUsername']=x;
  getMobile(String x) => details['mobile']=x;
  getEmail(String x) => details['email']=x;
  getDescription(String x) => details['description']=x;
  getWorkExperience(String x) => details['workExp']=x;
  getSkills(List<DocumentReference> x) => skills = x;

  Future<void> signUp(
      List<GlobalKey<FormState>> _formKey, BuildContext context) async {
    _formKey.forEach((form) {
      form.currentState.save();
    });
    try {
      isLoadingSignupExpert.updateStatus(true);
      userName = "expert_" + details["name"].split(" ")[0];
      String index = details['name'].substring(0, 1).toUpperCase();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: details['email'], password: details['password']);
      expert = new Experts(
          email: details['email'],
          city: details['city'],
          name: details['name'],
          skype: details['skypeUsername'],
          userId: userName,
          status: false,
          m: details['mobile'],
          index: index,
          description: details['description'],
          workExperience: details['workExp'],
          skills:skills);
          
      Firestore.instance.runTransaction((Transaction t) async {
        await expertReference.add(expert.toJson());
      });
      expertSnapshot = await expertReference
          .where('emailID', isEqualTo: details['email'])
          .getDocuments();
      currentExpert = expertSnapshot.documents[0];
      Navigator.pushNamedAndRemoveUntil(
          context, '/expert_home', ModalRoute.withName(':'));
      _formKey.forEach((form) {
        form.currentState.reset();
      });
    } catch (e) {
      //_isSignIn = false;
      _formKey.forEach((form) {
        form.currentState.reset();
      });
      details.clear();
      expert = null;
      isLoadingSignupExpert.updateStatus(false);
      _ackAlert(context, "SignUp failed", e.toString().split(',')[1]);
    }
  }

  Future<void> signIn(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    String _email;
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      isLoadingLoginExpert.updateStatus(true);
      //_isSignIn = true;
      formState.save();
      try {
        await Firestore.instance
            .collection("Experts")
            .where("userID", isEqualTo: details[0])
            .getDocuments()
            .then((QuerySnapshot q) {
          _email = q.documents[0]["emailID"];
        }).catchError((e) {
          _email = null;
        });
        if (_email == null) throw ("User not found!");
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: details[1]);
        expertSnapshot = await expertReference
            .where('emailID', isEqualTo: _email)
            .getDocuments();
        if (expertSnapshot.documents[0]["Status"] == false)
          throw ("Not Active");
        //print(expertSnapshot.documents[0]["emailID"]);
        currentExpert = expertSnapshot.documents[0];
        Navigator.pushNamedAndRemoveUntil(
            context, '/expert_home', ModalRoute.withName(':'));
        formState.reset();
      } catch (e) {
        //_isSignIn = false;
        //formState.reset();
        details.clear();
        isLoadingLoginExpert.updateStatus(false);
        _ackAlert(
            context,
            "Login Failed!",
            e == "Not Active" || e == "User not found!"
                ? e
                : e.toString().split(',')[1]);
      }
    }
  }
}
