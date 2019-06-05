import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/expert_authentication/get_all_skills.dart';

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
  final List<GlobalKey<FormState>> formKeyExpert = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  static final Authenticate authenticate = new Authenticate();
  bool loading = false;
  int step = 0;
  bool isExperienced = false;
  bool hasCertificate = false;
  GetSkills skills = GetSkills();
  Map<String, Map<String, dynamic>> skillsSelected = {
    "skill1": {
      'name': '',
      'reference': null,
    },
    "skill2": {
      'name': '',
      'reference': null,
    },
    "skill3": {
      'name': '',
      'reference': null,
    }
  };
  //List<DocumentReference> skillReference=[];

  @override
  void initState() {
    checkLoadingStatus();
    skills.getSkills();
    super.initState();
  }

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
      if (status) {
        showAuthSnackBar(
            context: context,
            title: "Signing In",
            leading: CircularProgressIndicator());
      } else {
        Scaffold.of(context).removeCurrentSnackBar();
      }
    });
  }

  void startAuthentication() {
    authenticate.signUp(formKeyExpert, context);
  }

  bool validateFormStep(GlobalKey<FormState> formkey) {
    return formkey.currentState.validate();
  }

  void onCustomButtonPressed(String selected) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoPicker(
            diameterRatio: 8,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            children: skills.getSkillAsWidget(context),
            onSelectedItemChanged: (item) {
              setState(() {
                skillsSelected[selected]['name'] = skills.skillName[item];
                skillsSelected[selected]['reference'] =
                    skills.skillReference[item];
              });
            },
            itemExtent: 30,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height*1.5,
        child: Theme(
          data: Theme.of(context).copyWith(
              primaryColor: Colors.blue, backgroundColor: Colors.blue),
          child: Stepper(
            physics: BouncingScrollPhysics(),
            type: StepperType.vertical,
            currentStep: step,
            onStepTapped: (tapped) {
              if (step == formKeyExpert.length - 1 &&
                  tapped < formKeyExpert.length - 1)
                setState(() {
                  step = tapped;
                });
              else if (validateFormStep(formKeyExpert[step])) {
                setState(() {
                  step = tapped;
                });
              }
            },
            onStepContinue: () {
              if (step < formKeyExpert.length - 1 &&
                  validateFormStep(formKeyExpert[step])) {
                setState(() {
                  step += 1;
                });
              } else {
                if (skillsSelected['skill1']['name'] == '') {
                  showAuthSnackBar(
                    context: context,
                    title: "Skill 1 is required",
                    leading: Icon(Icons.error, size: 25, color: Colors.red),
                  );
                } else {
                  startAuthentication();
                }
              }
            },
            steps: [
              Step(
                title: Text("Basic Information"),
                content: Form(
                  key: formKeyExpert[0],
                  child: Column(
                    children: <Widget>[
                      InputField("Name", authenticate.getName),
                      InputField("Email", authenticate.getEmail),
                      InputField("Skype username", authenticate.getSkype),
                      InputField("City", authenticate.getCity),
                      InputField("Mobile", authenticate.getMobile,
                          inputType: TextInputType.number),
                      InputField("Password", authenticate.getPass,
                          isPassword: true),
                    ],
                  ),
                ),
              ),
              Step(
                title: Text("About yourself"),
                content: Form(
                  key: formKeyExpert[1],
                  child: Column(
                    children: <Widget>[
                      InputField(
                        "Breif Discription",
                        authenticate.getDescription,
                        inputType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: null,
                        maxLength: 150,
                        inputAction: TextInputAction.newline,
                      ),
                      InputField(
                        "Previous Experience",
                        authenticate.getWorkExperience,
                        inputType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: null,
                        maxLength: 150,
                        inputAction: TextInputAction.newline,
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: Text("Skills"),
                content: Form(
                  key: formKeyExpert[2],
                  child: FormField(
                    onSaved: (state) {
                      List<DocumentReference> skillSelectedReference = [];
                      skillsSelected.forEach((key, value) {
                        if (value['reference'] != null) {
                          skillSelectedReference.add(value['reference']);
                        }
                      });
                      authenticate.getSkills(skillSelectedReference);
                    },
                    builder: (state) {
                      return Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  CustomFlatButton(
                                    text: "Select Skill",
                                    onPressedFunction: () {
                                      onCustomButtonPressed('skill1');
                                    },
                                  ),
                                  Text(
                                      (skillsSelected['skill1']['name'] == ''
                                          ? "Required"
                                          : skillsSelected['skill1']['name']),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .body2
                                          .copyWith(color: Colors.red))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  CustomFlatButton(
                                    text: "Select Skill",
                                    onPressedFunction: () {
                                      onCustomButtonPressed('skill2');
                                    },
                                  ),
                                  Text(
                                      (skillsSelected['skill2']['name'] == ''
                                          ? "Optional"
                                          : skillsSelected['skill2']['name']),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .body2
                                          .copyWith(color: Colors.blue))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  CustomFlatButton(
                                    text: "Select Skill",
                                    onPressedFunction: () {
                                      onCustomButtonPressed('skill3');
                                    },
                                  ),
                                  Text(
                                      (skillsSelected['skill3']['name'] == ''
                                          ? "Optional"
                                          : skillsSelected['skill3']['name']),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .body2
                                          .copyWith(color: Colors.blue))
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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
