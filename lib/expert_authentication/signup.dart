//import 'package:experto/user_authentication/signUpReq.dart';
import './signUpReq.dart';
import "package:flutter/material.dart";
import 'package:experto/user_page/bloc/is_loading.dart';

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
  final GlobalKey<FormState> formKeyExpert = GlobalKey<FormState>();
  static final Authenticate authenticate = new Authenticate();
  bool loading = false;
  int page = 1;
  bool isExperienced = false;
  bool hasCertificate = false;

  @override
  void dispose() {
    isLoadingSignupExpert.dispose();
    super.dispose();
  }

  void checkLoadingStatus() async {
    isLoadingSignupExpert.getStatus.listen((status) {
      setState(() {
        loading = status;
      });
    });
  }

  void startAuthentication() {
    authenticate.signUp(formKeyExpert, context);
  }

  Widget page1Entries() {
    return Column(children: <Widget>[
      InputField("Name", authenticate.getName),
      InputField("Email", authenticate.getEmail),
      InputField("Skype username", authenticate.getEmail),
      InputField("City", authenticate.getCity),
    ]);
  }

  Widget page2Entries() {
    return Column(
      children: <Widget>[
        InputField("Mobile", authenticate.getMobile,
            inputType: TextInputType.number),
        InputField("Password", authenticate.getPass, isPassword: true),
        Padding(padding:EdgeInsets.only(top:20)),
        Row(
          children: <Widget>[
            Text(
              'Do You Have Any Previous Experience',
              style: Theme.of(context).primaryTextTheme.body2,
            ),
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: isExperienced,
              onChanged: ((value) {
                setState(() {
                  isExperienced = value;
                });
              }),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'Do You Have Any Certificates',
              style: Theme.of(context).primaryTextTheme.body2,
            ),
            SizedBox(
              height: 5,
              child:Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: hasCertificate,
              onChanged: ((value) {
                setState(() {
                  hasCertificate = value;
                });
              }),
            ),),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    checkLoadingStatus();
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
        child: Form(
          key: formKeyExpert,
          child: Column(
            children: <Widget>[
              (page == 1) ? page1Entries() : page2Entries(),
              Hero(
                tag:"expertbuttonhero",
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        if (page == 1) {
                          setState(() {
                            page = 2;
                          });
                        }
                        if (page == 2) {
                          return (loading) ? null : startAuthentication;
                        }
                      },
                      elevation: 3,
                      highlightElevation: 4,
                      color: Color.fromRGBO(84, 229, 121, 1),
                      child: (page == 2)
                          ? authenticate.signInButton("Sign Up")
                          : Text(
                              "next",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
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
