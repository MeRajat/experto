import "package:flutter/material.dart";

import './app_bar.dart' as appBar;
import './signUpReq.dart';

import "package:experto/utils/bloc/is_loading.dart";

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
          SliverToBoxAdapter(
            child: Container(
              width: 20,
              padding: EdgeInsets.only(left: 23, bottom: 40, right: 23),
              child: Row(
                children: <Widget>[
                  Text("Don't have an account?",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .body2
                          .copyWith(fontSize: 13)),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/expert_signup');
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "SignUp",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .body2
                            .copyWith(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
  final GlobalKey<FormState> _formKeyExpert = GlobalKey<FormState>();
  Authenticate authenticate = new Authenticate();
  bool loading = false;

  @override
  void dispose() {
    isLoadingLoginExpert.dispose();
    super.dispose();
  }

  void checkLoadingStatus() async {
    isLoadingLoginExpert.getStatus.listen((status) {
      setState(() {
        loading = status;
      });
    });
  }

  void startAuthentication() {
    //authenticate.Clear();
    authenticate.signIn(_formKeyExpert, context);
  }

  @override
  Widget build(BuildContext context) {
    checkLoadingStatus();
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
        child: Form(
          key: _formKeyExpert,
          child: Column(
            children: <Widget>[
              InputField("Expertname", authenticate.getName),
              InputField("Password", authenticate.getPass, isPassword: true),
              Hero(
                tag:"expertbuttonhero",
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: (loading) ? null : startAuthentication,
                      elevation: 3,
                      highlightElevation: 4,
                      color: Color.fromRGBO(84, 229, 121, 1),
                      child: authenticate.signInButton("Sign In"),
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
