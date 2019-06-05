import 'package:experto/user_authentication/signUpReq.dart';
import "package:flutter/material.dart";
import "package:experto/utils/bloc/is_loading.dart";

import './app_bar.dart' as login_page_appbar;
import "package:experto/utils/authentication_page_utils.dart";

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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Authenticate authenticate = new Authenticate();
  bool loading = false;

  @override
  void dispose() {
    //isLoadingSignup.dispose();
    super.dispose();
  }

  @override
  void initState() {
    checkLoadingStatus();
    super.initState();
  }

  void checkLoadingStatus() async {
    isLoadingSignup.getStatus.listen((status) {
      setState(() {
        loading = status;
      });
      Scaffold.of(context).removeCurrentSnackBar();
      if (status) {
        showAuthSnackBar(
          context: context,
          title: "SigningIn",
          leading: CircularProgressIndicator(),
        );
      }
    });
  }

  void startAuthentication() {
    authenticate.signUp(formKey, context);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height * 1.5,
        child: Form(
          key: formKey,
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
                  title: Text("Enter Information"),
                  content: Column(
                    children: <Widget>[
                      InputField("Name", authenticate.getName),
                      InputField("Email", authenticate.getEmail),
                      InputField("City", authenticate.getCity),
                      InputField("Mobile", authenticate.getMobile,
                          inputType: TextInputType.number),
                      InputField("Password", authenticate.getPass,
                          isPassword: true),
                    ],
                  ),
                ),
                Step(
                  title: Text("Press Continue To SignUp"),
                  content: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // @override
    // Widget build(BuildContext context) {
    //   checkLoadingStatus();
    //   return SliverToBoxAdapter(
    //     child: Padding(
    //       padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
    //       child: Form(
    //         key: formKey,
    //         child: Column(
    //           children: <Widget>[
    //             InputField("Name", authenticate.getName),
    //             InputField("Email", authenticate.getEmail),
    //             InputField("City", authenticate.getCity),
    //             InputField("Mobile", authenticate.getMobile,inputType: TextInputType.number),
    //             InputField("Password", authenticate.getPass,
    //                 isPassword: true),
    //             Hero(
    //               tag:"userbuttonhero",
    //               child: Padding(
    //                 padding: EdgeInsets.only(top: 20),
    //                 child: SizedBox(
    //                   width:double.infinity,
    //                   child: RaisedButton(
    //                     onPressed: (loading) ? null : startAuthentication,
    //                     elevation: 3,
    //                     highlightElevation: 4,
    //                     color: Color.fromRGBO(84, 229, 121, 1),
    //                     //child: authenticate.signInButton("Sign Up")
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
}
