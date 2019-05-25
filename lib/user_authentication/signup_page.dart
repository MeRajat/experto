import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

import './app_bar_signup.dart' as login_page_appbar;

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          login_page_appbar.AppBar(),
          CustomFormField(),
        ],
      ),
    );
  }
}

class CustomFormField extends StatefulWidget {
  @override
  _CustomFormField createState() => _CustomFormField();
}

class _CustomFormField extends State<CustomFormField> {
  //final _globalKey = GlobalKey<FormState>();
  final List<FocusNode> nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Authenticate authenticate = new Authenticate();

  @override
  Widget build(BuildContext context) {
    return FormField(
        //key: _globalKey,
        builder: (currentState) {
      return SliverPadding(
        padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
            [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    InputField(nodes[0], "Name", authenticate.getName),
                    InputField(nodes[1], "Email", authenticate.getEmail),
                    InputField(nodes[2], "City", authenticate.getCity),
                    InputField(nodes[3], "Password", authenticate.getPass,
                        isPassword: true),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: RaisedButton(
                        onPressed: () {
                          authenticate.signUp(_formKey, context);
                        },
                        elevation: 3,
                        highlightElevation: 4,
                        color: Color.fromRGBO(84, 229, 121, 1),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class InputField extends StatelessWidget {
  final FocusNode node;
  final String hintText;
  final TextInputType inputType;
  final bool isPassword;
  final void Function(String) fn;

  InputField(this.node, this.hintText, this.fn,
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
            onSaved: (input) => fn(input),
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
  FirebaseUser user;
  List<String> details;
  bool _isSignIn;

  Authenticate() {
    _isSignIn = false;
    details = new List<String>();
  }

  getName(String x) => details.add(x);

  getPass(String x) => details.add(x);

  getCity(String x) => details.add(x);

  getEmail(String x) => details.add(x);

  Widget signInButton() {
    if (_isSignIn)
      return CircularProgressIndicator();
    else
      return Text(
        "Sign up",
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
        user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: details[1], password: details[3]);
        Navigator.pushNamedAndRemoveUntil(
            context, '/user_home', ModalRoute.withName(':'));
        formState.reset();
      } catch (e) {
        print(e.message);
      }
    }
  }
}
