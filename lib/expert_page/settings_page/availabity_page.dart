import 'package:experto/expert_authentication/get_all_skills.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import "package:experto/utils/authentication_page_utils.dart";
import "package:experto/utils/bloc/syncDocuments.dart";
import 'package:experto/global_data.dart';
import "package:experto/utils/bloc/syncDocuments.dart" as sync;

class Skills extends StatefulWidget {
  @override
  _SkillsState createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  Data expert;
  bool loadingSkillNames, loadingSkills;
  GlobalKey<FormState> key = GlobalKey();
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

  @override
  void initState() {
    skills.getSkills();
    loadingSkillNames = false;
    loadingSkills = false;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    expert = DocumentSync.of(context).account;

    setState(() {
      loadingSkillNames = true;
    });

    for (int i = 0; i < expert.detailsData["Skills"].length; i++) {
      skillsSelected["skill${i + 1}"]["reference"] =
          expert.detailsData["Skills"][i];
      skillsSelected["skill${i + 1}"]["name"] =
          await getSkillName(expert.detailsData["Skills"][i]);
    }

    setState(() {
      loadingSkillNames = false;
    });

    super.didChangeDependencies();
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

  getSkillName(DocumentReference skill) async {
    DocumentSnapshot skillSnapshot = await skill.get();
    return skillSnapshot["Name"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                height: 180,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).appBarTheme.color,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Skills",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 30),
                  ),
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.blue,
                  backgroundColor: Colors.blue[800],
                ),
                child: Stepper(
                  physics: BouncingScrollPhysics(),
                  onStepCancel: Navigator.of(context).pop,
                  onStepContinue: () async {
                    if (skillsSelected['skill1']['name'] == '') {
                      showAuthSnackBar(
                        context: context,
                        title: "Skill 1 is required",
                        leading: Icon(Icons.error, size: 25, color: Colors.red),
                      );
                    } else {
                      showAuthSnackBar(
                        context: context,
                        title: "Skills updated",
                        persistant: false,
                        leading:
                            Icon(Icons.done, size: 25, color: Colors.green),
                      );
                      List<DocumentReference> skillSelectedReference = [];
                      skillsSelected.forEach((key, value) {
                        if (value['reference'] != null) {
                          skillSelectedReference.add(value['reference']);
                        }
                      });
                      expert.detailsData.reference
                          .updateData({"Skills": skillSelectedReference});
                      Data newData = Data();
                      newData.profileData = expert.profileData;
                      newData.detailsData =
                          await expert.detailsData.reference.get();
                      syncDocument.updateStatus(newData);
                    }
                  },
                  steps: [
                    Step(
                      title: Text("Select new skills"),
                      content: Form(
                        key: key,
                        child: (loadingSkillNames == true)
                            ? Center(
                                heightFactor: 2,
                                child: CircularProgressIndicator())
                            : Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SignupSkillSelector(
                                        correspondingSkill: 'skill1',
                                        callbackFunc: () {
                                          onCustomButtonPressed('skill1');
                                        },
                                        color: Colors.red,
                                        skillsSelected: skillsSelected,
                                      ),
                                      SignupSkillSelector(
                                        correspondingSkill: 'skill2',
                                        callbackFunc: () {
                                          onCustomButtonPressed('skill2');
                                        },
                                        skillsSelected: skillsSelected,
                                      ),
                                      SignupSkillSelector(
                                        correspondingSkill: 'skill3',
                                        callbackFunc: () {
                                          onCustomButtonPressed('skill3');
                                        },
                                        skillsSelected: skillsSelected,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Availablity extends StatefulWidget {
  @override
  _AvailablityState createState() => _AvailablityState();
}

class _AvailablityState extends State<Availablity> {
  Data expert;
  GlobalKey<FormState> key = GlobalKey();
  bool loading, availablitySwitchValue, scheduleSwitchValue;
  Map<String, Map<String, dynamic>> availablity;

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
    loading = false;
    availablitySwitchValue = expert.detailsData["Available"];
    scheduleSwitchValue =
        (expert.detailsData['Availability Mode'] == 'schedule') ? true : false;
    availablity = {};
    expert.detailsData['Availablity'].forEach((slotName, timeSlot) {
      availablity[slotName] = {};
      availablity[slotName].update('start', (timeSlot) => timeSlot['start'],
          ifAbsent: () => timeSlot['start']);
      availablity[slotName].update('end', (timeSlot) => timeSlot['end'],
          ifAbsent: () => timeSlot['end']);
    });
    super.didChangeDependencies();
  }

  void syncDocument() async {
    expert.detailsData.reference.get().then((snapshot) {
      Data newExpert = Data();
      newExpert.detailsData = snapshot;
      newExpert.profileData = expert.profileData;
      sync.syncDocument.updateStatus(newExpert);
    });
  }

  void onCstmBtnPressedAvail(String slotSelected, String secondarySlot) {
    DatePicker.showDatePicker(
      context,
      pickerMode: DateTimePickerMode.time,
      onChange: (timeSelected, values) {
        setState(
          () {
            availablity[slotSelected][secondarySlot] =
                Timestamp.fromDate(timeSelected);
          },
        );
      },
      pickerTheme: DateTimePickerTheme(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        itemTextStyle:
            Theme.of(context).primaryTextTheme.body2.copyWith(fontSize: 15),
        confirmTextStyle: Theme.of(context).primaryTextTheme.body2,
      ),
    );
  }

  List<Widget> getTimeSlots() {
    List<Widget> slots = [];
    availablity.forEach((slotName, timeSlot) {
      slots.add(
        SignupTimeSelector(
          headingText: "Time Slot",
          availablity: timeSlot,
          slot: slotName,
          callbackFunc: onCstmBtnPressedAvail,
          selector1Color: Colors.blue,
          selector2Color: Colors.blue,
        ),
      );
    });
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return ListView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                height: 180,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).appBarTheme.color,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Availablity",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 30),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 40),
                child: ListTile(
                  title: Text("Avaliablity"),
                  subtitle: Text("Are you available to take calls from users"),
                  trailing: Switch(
                    value: availablitySwitchValue,
                    onChanged: (scheduleSwitchValue == true)
                        ? null
                        : (value) {
                            setState(() {
                              availablitySwitchValue = value;
                              expert.detailsData.reference
                                  .updateData({"Available": value});
                              syncDocument();
                            });
                          },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 40),
                child: ListTile(
                  title: Text("Add Schedule"),
                  subtitle: Text("Add schedule when a use can contact you"),
                  trailing: Switch(
                    value: scheduleSwitchValue,
                    onChanged: (value) {
                      setState(
                        () {
                          scheduleSwitchValue = value;
                          availablitySwitchValue = !value;
                          expert.detailsData.reference.updateData(
                            {
                              "Availability Mode":
                                  (value) ? "schedule" : "normal",
                              "Available": (value) ? false : true
                            },
                          );
                          syncDocument();
                        },
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
              ),
              (scheduleSwitchValue == false)
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Form(
                          key: key,
                          child: FormField(
                            onSaved: (_) {
                              expert.detailsData.reference
                                  .updateData({"Availablity": availablity});
                              syncDocument();
                            },
                            validator: (_) {
                              bool error = false;
                              String title;
                              if (availablity['slot1']['start'] == null ||
                                  availablity['slot1']['end'] == null) {
                                title = "Time Slot 1 is required";
                                error = true;
                              } else {
                                availablity.forEach(
                                  (key, value) {
                                    if ((value['start'] == null &&
                                            value['end'] != null) ||
                                        value['end'] == null &&
                                            value['start'] != null) {
                                      title =
                                          "Incomplete time slot encountered";
                                      error = true;
                                    }
                                  },
                                );
                              }
                              if (error == true) {
                                showAuthSnackBar(
                                  context: context,
                                  title: title,
                                  leading: Icon(
                                    Icons.error,
                                    size: 25,
                                    color: Colors.red,
                                  ),
                                );
                                return 'error';
                              } else {
                                key.currentState.save();
                                showAuthSnackBar(
                                    context: context,
                                    title: "Time Slot Updated",
                                    leading: Icon(Icons.done,
                                        color: Colors.green, size: 25),
                                    persistant: false);
                              }
                            },
                            builder: (state) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: getTimeSlots(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        FlatButton(
                          onPressed: () {
                            key.currentState.validate();
                          },
                          child: Text("Update"),
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Colors.blue[800]
                                  : Colors.blue,
                        ),
                      ],
                    ),
              Padding(padding: EdgeInsets.all(100)),
            ],
          );
        },
      ),
    );
  }
}
