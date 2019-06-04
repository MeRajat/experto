import './signUpReq.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';

import "package:experto/utils/bloc/is_loading.dart";
import "package:experto/utils/authentication_page_utils.dart";

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
  int step = 0;
  bool isExperienced = false;
  bool hasCertificate = false;

  @override
  void dispose() {
    //isLoadingSignupExpert.dispose();
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

  @override
  Widget build(BuildContext context) {
    checkLoadingStatus();
    return SliverToBoxAdapter(
      child: Container(
        height: 700,
        child: Form(
          key: formKeyExpert,
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.blue,
              backgroundColor: Colors.blue
            ),
            child: Stepper(
              physics: BouncingScrollPhysics(),
              type: StepperType.vertical,
              currentStep: step,
              onStepTapped: (int stepTapped) {
                setState(() {
                  step = stepTapped;
                });
              },
              onStepContinue: () {
                setState(() {
                  step += 1;
                });
              },
              steps: [
                Step(
                  title: Text("Basic Information"),
                  content: Column(
                    children: <Widget>[
                      InputField("Name", authenticate.getName),
                      InputField("Email", authenticate.getEmail),
                      InputField("Skype username", authenticate.getSkype),
                      InputField("Mobile", authenticate.getMobile,
                          inputType: TextInputType.number),
                      InputField("Password", authenticate.getPass,
                          isPassword: true),
                    ],
                  ),
                ),
                Step(
                  title: Text("About yourself"),
                  content: Column(
                    children: <Widget>[
                      InputField(
                        "Breif Discription",
                        authenticate.getName,
                        inputType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: null,
                        maxLength: 150,
                        inputAction: TextInputAction.newline,
                      ),
                      InputField(
                        "Previous Experience",
                        authenticate.getName,
                        inputType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: null,
                        maxLength: 150,
                        inputAction: TextInputAction.newline,
                      ),
                    ],
                  ),
                ),
                Step(
                  title: Text("Skills"),
                  content: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CustomFlatButton(text: "Select Skill"),
                              Text("Required",style:Theme.of(context).primaryTextTheme.body2.copyWith(color:Colors.red))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              CustomFlatButton(text: "Select Skill"),
                              Text("Optional",style:Theme.of(context).primaryTextTheme.body2.copyWith(color:Colors.blue))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              CustomFlatButton(text: "Select Skill"),
                              Text("Optional",style:Theme.of(context).primaryTextTheme.body2.copyWith(color:Colors.blue))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // return SliverToBoxAdapter(
    //   child: Padding(
    //     padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
    //     child: Form(
    //       key: formKeyExpert,
    //       child: Column(
    //         children: <Widget>[
    //           InputField("Name", authenticate.getName),
    //           InputField("Email", authenticate.getEmail),
    //           InputField("Skype username", authenticate.getSkype),
    //           InputField("City", authenticate.getCity),
    //           InputField("Mobile", authenticate.getMobile,
    //               inputType: TextInputType.number),
    //           InputField("Password", authenticate.getPass, isPassword: true),
    //           Padding(padding:EdgeInsets.only(top:20)),
    //           Row(
    //             children: <Widget>[
    //               Text(
    //                 'Do You Have Any Previous Experience',
    //                 style: Theme.of(context).primaryTextTheme.body2,
    //               ),
    //               Checkbox(
    //                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //                 value: isExperienced,
    //                 onChanged: ((value) {
    //                   setState(() {
    //                     isExperienced = value;
    //                   });
    //                 }),
    //               ),
    //             ],
    //           ),
    //           Row(
    //             children: <Widget>[
    //               Text(
    //                 'Do You Have Any Certificates',
    //                 style: Theme.of(context).primaryTextTheme.body2,
    //               ),
    //               SizedBox(
    //                 height: 5,
    //                 child:Checkbox(
    //                   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //                   value: hasCertificate,
    //                   onChanged: ((value) {
    //                     setState(() {
    //                       hasCertificate = value;
    //                     });
    //                   }),
    //                 ),),
    //             ],
    //           ),
    //           Hero(
    //             tag:"expertbuttonhero",
    //             child: Padding(
    //               padding: EdgeInsets.only(top: 20),
    //               child: SizedBox(
    //                 width: double.infinity,
    //                 child: RaisedButton(
    //                   onPressed: startAuthentication,
    //                   elevation: 3,
    //                   highlightElevation: 4,
    //                   color: Color.fromRGBO(84, 229, 121, 1),
    //                   child: authenticate.signInButton("Sign Up"),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
