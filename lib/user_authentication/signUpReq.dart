import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class InputField extends StatelessWidget {
  final FocusNode node;
  final String hintText;
  final TextInputType inputType;
  final bool isPassword;
  final void Function(String) fn;

  InputField(this.node, this.hintText, this.fn,{this.inputType: TextInputType.text,this.isPassword: false});

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
            focusNode: node,
            obscureText: isPassword,
            validator: (value) {
              if (value.isEmpty) {
                return 'please enter this field';
              }
            },
            // onFieldSubmitted: (text) {
            //   if (index <= nodes.length - 1) {
            //     FocusScope.of(context)
            //         .requestFocus(nodes[index + 1]);
            //   } else {
            //     print("form submitted");
            //   }
            // },
            onSaved:(input)=>fn(input),
            //textInputAction: TextInputAction.next,
            //keyboardType: inputType,
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

class Authenticate{
  FirebaseUser user;
  List<String> details;
  bool _isSignIn;
  Authenticate(){
    _isSignIn=false;
    details=new List<String>();
  }

  getName(String x)=>
      details.add(x);
  getPass(String x)=>
      details.add(x);
  getCity(String x)=>
      details.add(x);
  getEmail(String x)=>
      details.add(x);

  Widget signInButton(String x){
    if(_isSignIn)
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

  Future<void> signUp(GlobalKey<FormState> _formKey,BuildContext context) async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        _isSignIn=true;
        user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: details[1], password: details[3]);
        Navigator.pushNamedAndRemoveUntil(
            context, '/user_home', ModalRoute.withName(':'));
        formState.reset();
      } catch (e) {
        print(e.message);
      }
    }
  }
  Future<void> signIn(GlobalKey<FormState> _formKey,BuildContext context) async{
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseAuth.instance.signInWithEmailAndPassword(email: details[0], password: details[1]);
        Navigator.pushNamedAndRemoveUntil(
            context, '/user_home', ModalRoute.withName(':'));
        formState.reset();
      } catch (e) {
        print(e.message);
      }
    }
  }
}