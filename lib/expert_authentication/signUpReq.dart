import 'package:experto/expert_authentication/expertAdd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../user_page/bloc/is_loading.dart';

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
  CollectionReference expertReference;
  QuerySnapshot expertSnapshot;
  List<String> details;
  String userName;
  bool _isSignIn;
  Future<void> Function(BuildContext context) fn;

  Authenticate() {
    _isSignIn = false;
    details = new List<String>();
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

  getName(String x) => details.add(x);
  getPass(String x) => details.add(x);
  getCity(String x) => details.add(x);
  getSkype(String x) => details.add(x);
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
    if (formState.validate()) {
      formState.save();
      try {
        isLoadingSignupExpert.updateStatus(true);
        _isSignIn = true;
        userName="expert_"+details[0];
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: details[1], password: details[5]);
        expert = new Experts(
            email: details[1],
            city: details[3],
            name: details[0],
            skype: details[2],
            userId: userName,
            status: false,
            m: details[4]);
        Firestore.instance.runTransaction((Transaction t) async {
          await expertReference.add(expert.toJson());
        });
        expertSnapshot = await expertReference
            .where('emailID', isEqualTo: details[1])
            .getDocuments();
        currentExpert=expertSnapshot.documents[0];
        if(!currentExpert["Status"])
          throw("Not Active");
        Navigator.pushNamedAndRemoveUntil(
            context, '/expert_home', ModalRoute.withName(':'));
        formState.reset();
      } catch (e) {
        _isSignIn = false;
        formState.reset();
        details.clear();
        expert=null;
        isLoadingSignupExpert.updateStatus(false);
        _ackAlert(context, "SignUp Failed!", (e=="Not Active") ? e: "Incorrect Details");
      }
    }
  }

  Future<void> signIn(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    String _email;
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      isLoadingLoginExpert.updateStatus(true);
      _isSignIn = true;
      formState.save();
      try {
        await Firestore.instance.collection("Experts").where("userID",isEqualTo: details[0]).getDocuments().then((QuerySnapshot q){
          _email=q.documents[0]["emailID"];
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email, password: details[1]);
        expertSnapshot = await expertReference
            .where('emailID', isEqualTo: _email)
            .getDocuments();
        //print(expertSnapshot.documents[0]["emailID"]);
        currentExpert=expertSnapshot.documents[0];
        Navigator.pushNamedAndRemoveUntil(
            context, '/expert_home', ModalRoute.withName(':'));
        formState.reset();
      } catch (e) {
        _isSignIn = false;
        //formState.reset();
        details.clear();
        isLoadingLoginExpert.updateStatus(false);
        _ackAlert(
            context, "Login Failed!", "Expertname or password is Incorrect");
      }
    }
  }
}
