import "package:flutter/material.dart";

import './app_bar.dart' as appBar;
import './signUpReq.dart';
import './signup_page.dart' as signup;

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          appBar.AppBar("Login"),
          CustomForm(),
        ],
      ),
    );
  }
}

class CustomForm extends StatefulWidget {
  @override
  _CustomForm createState() => _CustomForm();
}

class _CustomForm extends State<CustomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<FocusNode> _nodes = [FocusNode(), FocusNode()];
  final Authenticate authenticate = new Authenticate();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              signup.InputField(_nodes[0], "Email", authenticate.getName),
              signup.InputField(_nodes[1], "Password", authenticate.getPass,
                  isPassword: true),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      authenticate.signIn(_formKey, context);
                    },
                    elevation: 3,
                    highlightElevation: 4,
                    color: Color.fromRGBO(84, 229, 121, 1),
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
