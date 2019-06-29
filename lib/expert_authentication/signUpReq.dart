import 'package:experto/expert_authentication/expertData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";

import "package:experto/utils/bloc/is_loading.dart";
import 'package:experto/global_data.dart';

class Authenticate {
  CollectionReference expertReference;
  QuerySnapshot expertSnapshot;
  AuthException exception;
  Map<String, dynamic> details;
  List<DocumentReference> skills;
  Map<String, Map<String, DateTime>> availablity;
  List<Map<String, DateTime>> avail = new List<Map<String, DateTime>>();
  String userName;
  String msg;
  Data expertData;
  //_isSignIn = false;
  //bool _isSignIn;
  Future<void> Function(BuildContext context) fn;

  Authenticate() {
    //_isSignIn = false;
    //details = new List<String>();
    expertData = new Data();
    details = {
      "name": "",
      "password": "",
      "email": "",
      "skypeUsername": "",
      "city": "",
      "mobile": '',
      "description": "",
      "workExp": ''
    };
    getExpert();
    msg = "Invalid details";
  }

  void clear() {
    details = {
      "name": "",
      "password": "",
      "email": "",
      "skypeUsername": "",
      "city": "",
      "mobile": '',
      "description": "",
      "workExp": ''
    };
    getExpert();
    msg = "Invalid details";
    expertData.profileData = null;
  }

  void updateConfig() async {
    final pref = await SharedPreferences.getInstance();
    final String key = "account_type";
    pref.setString(key, "expert");
  }

  Future<bool> isSignIn(context) async {
    expertData.profileData = await FirebaseAuth.instance.currentUser();
    try {
      if (expertData.profileData == null) {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/expert_login');
        return false;
      } else {
        expertData.detailsData =
            await expertReference.document(expertData.profileData.uid).get();
        if (!expertData.detailsData.exists) throw ("error");
        Navigator.pushNamedAndRemoveUntil(
            context, '/expert_home', ModalRoute.withName(':'),
            arguments: expertData);
        return true;
      }
    } catch (e) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/expert_login');
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

  getExpert() async {
    expertReference = Firestore.instance.collection("Experts");
  }

  getName(String x) => details['name'] = x;

  getPass(String x) => details['password'] = x;

  getCity(String x) => details['city'] = x;

  getSkype(String x) => details['skypeUsername'] = x;

  getMobile(String x) => details['mobile'] = x;

  getEmail(String x) => details['email'] = x;

  getDescription(String x) => details['description'] = x;

  getWorkExperience(String x) => details['workExp'] = x;

  getSkills(List<DocumentReference> x) => skills = x;

  getAvailablity(Map<String, Map<String, DateTime>> x) => availablity = x;

  Future<void> signUp(
      List<GlobalKey<FormState>> _formKey, BuildContext context) async {
    _formKey.forEach((form) {
      form.currentState.save();
    });
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    try {
      isLoadingSignupExpert.updateStatus(true);
      userName = "expert_" + details["name"].split(" ")[0];
      String index = details['name'].substring(0, 1).toUpperCase();
      expertData.profileData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: details['email'], password: details['password']);
      currentExpert = new Experts(
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
        skills: skills,
      );
      userUpdateInfo.displayName = details['name'];
      await expertData.profileData.updateProfile(userUpdateInfo);
      Firestore.instance.runTransaction((Transaction t) async {
        await expertReference
            .document(expertData.profileData.uid)
            .setData(currentExpert.toJson());
      });
      throw ("Not Active");
    } catch (e) {
      details.clear();
      expertData.detailsData = null;
      isLoadingSignupExpert.updateStatus(false);
      _ackAlert(context, e == "Not Active" ? "In Review" : "SignUp failed",
          e == "Not Active" ? e : e.toString().split(',')[1]);
    }
  }

  Future<void> signIn(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    details.clear();
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      isLoadingLoginExpert.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      //_isSignIn = true;
      formState.save();
      try {
        await Firestore.instance
            .collection("Experts")
            .where("emailID", isEqualTo: details['email'])
            .getDocuments()
            .then((QuerySnapshot q) {
          if (q.documents.isEmpty) throw ("User not found!");
          if (q.documents[0]["Status"] == false) throw ("Not Active");
          details['email'] = q.documents[0]["emailID"];
        });
        expertData.profileData = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: details['email'], password: details['password']);
        expertData.detailsData =
            await expertReference.document(expertData.profileData.uid).get();
        updateConfig();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/expert_home',
          ModalRoute.withName(':'),
          arguments: expertData,
        );
        formState.reset();
      } catch (e) {
        details.clear();
        isLoadingLoginExpert.updateStatus(false);
        _ackAlert(
            context,
            "Login Failed!",
            e == "Not Active" || e == "User not found!"
                ? e
                : e.toString().split(',')[0]);
      }
    }
  }
}
