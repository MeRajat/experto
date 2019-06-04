import "package:flutter/material.dart";

import './app_bar.dart' as appBar;
import './signUpReq.dart';
import "package:experto/utils/bloc/is_loading.dart";
import "package:experto/utils/authentication_page_utils.dart";

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
  final Authenticate authenticate = new Authenticate();
  bool loading = false;

  @override
  void initState() {
    checkLoadingStatus();
    super.initState();
  }

  @override
  void dispose() {
    //isLoadingLogin.dispose();
    super.dispose();
  }

  void checkLoadingStatus() async {
    isLoadingLogin.getStatus.listen((status) {
      loading = status;
      if (status) {
        showAuthSnackBar(context:context,title:"Logging In");
      } else {
        Scaffold.of(context).removeCurrentSnackBar();
      }
    });
  }

  void startAuthentication() {
    authenticate.signIn(_formKey, context);
  }

  void redirectCallbackFunc() {
    Navigator.of(context).pushNamed("/user_signup");
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 600,
        child: Form(
          key: _formKey,
          child: Theme(
            data: Theme.of(context).copyWith(
                primaryColor: Colors.blue, backgroundColor: Colors.blue),
            child: Stepper(
              physics: BouncingScrollPhysics(),
              type: StepperType.vertical,
              currentStep: 0,
              onStepTapped: (int tapped) {},
              onStepContinue: (loading) ? null : startAuthentication,
              steps: [
                Step(
                  title: Text("Enter Credentials"),
                  content: Column(
                    children: <Widget>[
                      InputField("Email", authenticate.getName),
                      InputField("Password", authenticate.getPass,
                          isPassword: true),
                      SignupPageRedirect(
                        text: "Don't have an account?",
                        redirectLink: "SignUp",
                        callback: redirectCallbackFunc,
                      )
                    ],
                  ),
                ),
                Step(
                  title: Text("Press Continue To LogIn"),
                  content: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   checkLoadingStatus();
  //   return SliverToBoxAdapter(
  //     child: Padding(
  //       padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
  //       child: Form(
  //         key: _formKey,
  //         child: Column(
  //           children: <Widget>[
  //             InputField("Email", authenticate.getName),
  //             InputField("Password", authenticate.getPass,
  //                 isPassword: true),
  //             Hero(
  //               tag:"userbuttonhero",
  //               child: Padding(
  //                 padding: EdgeInsets.only(top: 20),
  //                 child: SizedBox(
  //                   width: double.infinity,
  //                   child: RaisedButton(
  //                     onPressed: (loading)?null:startAuthentication,
  //                     elevation: 3,
  //                     highlightElevation: 4,
  //                     color: Color.fromRGBO(84, 229, 121, 1),
  //                     child: authenticate.signInButton("Sign In"),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
