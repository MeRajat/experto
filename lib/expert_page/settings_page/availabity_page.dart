import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import "package:experto/utils/authentication_page_utils.dart";
import "package:experto/expert_page/expert_home.dart";
import "package:experto/utils/bloc/syncDocuments.dart";

class Availablity extends StatefulWidget {
  @override
  _AvailablityState createState() => _AvailablityState();
}

class _AvailablityState extends State<Availablity> {
  DocumentSnapshot expert;
  GlobalKey<FormState> key = GlobalKey();
  bool loading, availablitySwitchValue, scheduleSwitchValue;
  Map availablity;

  @override
  void didChangeDependencies() {
    expert = ExpertDocumentSync.of(context).expert;
    loading = false;
    availablitySwitchValue = expert["Available"];
    scheduleSwitchValue =
        (expert['Availability Mode'] == 'schedule') ? true : false;
    availablity = expert['Availablity'];
    super.didChangeDependencies();
  }

  void syncDocument() async {
    expert.reference.get().then((snapshot) {
      syncDocumentExpert.updateStatus(snapshot);
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
          availablity: availablity,
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
                              expert.reference.updateData({"Available": value});
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
                          expert.reference.updateData(
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
                              expert.reference
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
