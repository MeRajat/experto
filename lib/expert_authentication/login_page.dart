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
  final GlobalKey<FormState> _formKeyExpert = GlobalKey<FormState>();
  final Authenticate authenticate = new Authenticate();
  bool loading = false;
  final List<FocusNode> focusNode = [FocusNode(), FocusNode()];

  @override
  void initState() {
    checkLoadingStatus();
    super.initState();
  }

  @override
  void dispose() {
    //isLoadingLoginExpert.dispose();
    super.dispose();
  }

  void checkLoadingStatus() async {
    isLoadingLoginExpert.getStatus.listen((status) {
      setState(() {
        loading = status;
      });
      Scaffold.of(context).removeCurrentSnackBar();
      if (status) {
        loading = true;
        showAuthSnackBar(
            context: context,
            title: "Logging In",
            leading: CircularProgressIndicator());
      }
    });
  }

  void startAuthentication() {
    authenticate.clear();
    authenticate.signIn(_formKeyExpert, context);
  }

  void redirectCallbackFunc() {
    Navigator.of(context).pushNamed("/expert_signup");
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 600,
        child: Form(
          key: _formKeyExpert,
          child: Theme(
            data: Theme.of(context).copyWith(
                primaryColor: Colors.blue,
                backgroundColor: Color.fromRGBO(42, 123, 249, 1)),
            child: Stepper(
              physics: BouncingScrollPhysics(),
              type: StepperType.vertical,
              currentStep: 0,
              onStepTapped: (int tapped) {},
              onStepContinue: (loading == true) ? null : startAuthentication,
              onStepCancel: (loading == true)
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
              steps: [
                Step(
                  title: Text("Enter Credentials"),
                  content: Column(
                    children: <Widget>[
                      InputField(
                        "Enter Your Username",
                        authenticate.getEmail,
                        focusNode: focusNode[0],
                        nextTextField: focusNode[1],
                      ),
                      InputField(
                        "Enter Your Password",
                        authenticate.getPass,
                        isPassword: true,
                        focusNode: focusNode[1],
                        inputAction: TextInputAction.done,
                        func: startAuthentication,
                      ),
                      SignupPageRedirect(
                        text: "Don't have an account?",
                        redirectLink: "SignUp",
                        callback: redirectCallbackFunc,
                      )
                    ],
                  ),
                ),
                // Step(
                //   title: Text("Press Continue To LogIn"),
                //   content: Container(),
                // ),
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
  //         key: _formKeyExpert,
  //         child: Column(
  //           children: <Widget>[
  //             InputField("Expertname", authenticate.getName),
  //             InputField("Password", authenticate.getPass, isPassword: true),
  //             Hero(
  //               tag:"expertbuttonhero",
  //               child: Padding(
  //                 padding: EdgeInsets.only(top: 20),
  //                 child: SizedBox(
  //                   width: double.infinity,
  //                   child: RaisedButton(
  //                     onPressed: (loading) ? null : startAuthentication,
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
