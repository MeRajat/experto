import 'package:experto/user_authentication/signUpReq.dart';
import "package:flutter/material.dart";

import './app_bar.dart' as login_page_appbar;

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          login_page_appbar.AppBar("Sign up"),
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
  final List<FocusNode> nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Authenticate authenticate = new Authenticate();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              InputField(nodes[0], "Name", authenticate.getName),
              InputField(nodes[1], "Email", authenticate.getEmail),
              InputField(nodes[2], "City", authenticate.getCity),
              InputField(nodes[3], "Mobile", authenticate.getMobile,inputType: TextInputType.number),
              InputField(nodes[4], "Password", authenticate.getPass,
                  isPassword: true),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width:double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      authenticate.signUp(formKey, context);
                    },
                    elevation: 3,
                    highlightElevation: 4,
                    color: Color.fromRGBO(84, 229, 121, 1),
                    child: authenticate.signInButton("Sign Up")
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