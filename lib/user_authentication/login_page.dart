import "package:flutter/material.dart";

import './app_bar.dart' as appBar;
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
          appBar.AppBar("Login Page"),
          CustomTextFormField(),
        ],
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<FocusNode> nodes = [FocusNode(), FocusNode()];
  final signup.Authenticate authenticate=new signup.Authenticate();


  void random(String x){

  }

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
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        signup.InputField(nodes[0], "Email", authenticate.getName ),
                        signup.InputField(nodes[1], 'Password', authenticate.getPass,isPassword: true),
                        Padding(
                            padding: EdgeInsets.only(top:20),
                            child: RaisedButton(
                              onPressed: (){authenticate.signIn(formKey,context);},
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
