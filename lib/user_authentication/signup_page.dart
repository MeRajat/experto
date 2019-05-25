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
          SliverToBoxAdapter(
            child: Container(
              width:20,
              padding: EdgeInsets.only(left: 23, bottom: 40,right:23),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/user_login');
                },
                child: Text("Already have an account?   Login",style:Theme.of(context).primaryTextTheme.body2.copyWith(fontSize: 13)),
              ),
            ),
          )
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
  final List<FocusNode> nodes = [FocusNode(), FocusNode(), FocusNode(),FocusNode()];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Authenticate authenticate=new Authenticate();

  @override
  Widget build(BuildContext context) {
    return FormField(
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
                    InputField(nodes[0], "Name",authenticate.getName),
                    InputField(nodes[1], "Email",authenticate.getEmail),
                    InputField(nodes[2], "City",authenticate.getCity),
                    InputField(nodes[3], "Password",authenticate.getPass,isPassword: true),
                    Padding(
                      padding: EdgeInsets.only(top:20),
                      child: RaisedButton(
                        onPressed: (){authenticate.signUp(_formKey,context);},
                        elevation: 3,
                        highlightElevation: 4,
                        color: Color.fromRGBO(84, 229, 121, 1),
                        child: authenticate.signInButton("Sign Up"),
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