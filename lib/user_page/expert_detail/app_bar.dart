import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/user_authentication/userData.dart';
import "package:experto/utils/bloc/reload.dart";

import 'package:experto/utils/bottomSheet.dart' as bottomSheet;
import 'package:experto/utils/contact_expert.dart' as contactExpert;

import 'package:flutter/material.dart';
import "package:flutter/cupertino.dart";

import "package:experto/utils/global_app_bar.dart";
import './feedback.dart' as expert_feedback;

class AppBar extends StatelessWidget {
  final DocumentSnapshot expert;

  AppBar(this.expert);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      250,
      'Detail',
      CustomFlexibleSpaceBar(expert),
    );
  }
}

class CustomFlexibleSpaceBar extends StatelessWidget {
  final DocumentSnapshot expert;

  CustomFlexibleSpaceBar(this.expert);

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.all(0),
      background: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: expert['emailID'],
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 80),
              child: Icon(
                Icons.person,
                size: 110,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  child: Text(
                    expert["Name"],
                    style: Theme.of(context).textTheme.title.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: -.5,
                        ),
                  ),
                ),
                Container(
                  width: 200,
                  child: Text(
                    expert["emailID"],
                    style: Theme.of(context).primaryTextTheme.body1.copyWith(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Hero(
                    tag: "contact",
                    child: ContactExpert(expert),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactExpert extends StatefulWidget {
  final DocumentSnapshot expert;
  ContactExpert(this.expert);

  @override
  _ContactExpert createState() => _ContactExpert(expert);
}

class _ContactExpert extends State<ContactExpert> {
  bool checkingAvail = true;
  bool expertAvailable = true;
  DocumentSnapshot expert;
  DocumentSnapshot user;
  CollectionReference interaction;

  @override
  void didChangeDependencies() {
    user = UserDocumentSync.of(context).user;
    super.didChangeDependencies();
  }

  _ContactExpert(this.expert) {
    getInteraction();
  }

  void getInteraction() {
    interaction = Firestore.instance.collection("Interactions");
  }

  Future<void> updateInteraction() async {
    int id;
    QuerySnapshot tempsnap;
    CollectionReference temp = Firestore.instance.collection("Users"),
        temp2 = Firestore.instance.collection("Experts");
    try {
      for (int i = 0; i < user["interactionID"].length; i++) {
        tempsnap = await interaction
            .where("id", isEqualTo: user["interactionID"][i])
            .getDocuments();
        if (tempsnap.documents[0]["expert"] == expert["emailID"])
          break;
        else
          tempsnap = null;
      }
    } catch (e) {
      tempsnap = null;
      print("doesnt exist");
    }

    await Firestore.instance.runTransaction((Transaction t) async {
      await interaction.getDocuments().then((QuerySnapshot snapshot) {
        id = snapshot.documents.length;
      });
      if (tempsnap != null) {
        await interaction
            .document(tempsnap.documents[0].documentID)
            .updateData({
          "interactionTime": FieldValue.arrayUnion([DateTime.now()])
        });
      } else {
        await temp.document(user.documentID).updateData({
          "interactionID": FieldValue.arrayUnion([id])
        });
        print(expert["emailID"]);
        await temp2.document(expert.documentID).updateData({
          "interactionID": FieldValue.arrayUnion([id])
        });
        await interaction.add({
          'expert': expert["emailID"],
          'user': user["emailID"],
          'id': id,
          'interactionTime': FieldValue.arrayUnion([DateTime.now()])
        });
      }
      await temp
          .where("emailID", isEqualTo: user["emailID"])
          .getDocuments()
          .then((QuerySnapshot q) {
        user = q.documents[0];
      });
    });
    userSearchExpert.updateStatus(true);
  }

  Future<void> checkAvail() async {
    setState(() {
      checkingAvail = true;
    });

    expert = await expert.reference.get();

    if (expert["Availability Mode"] == 'normal') {
      expertAvailable = expert['Available'];
    } else {
      DateTime now = DateTime.now();
      var expertAvailability = expert["Availablity"];
      expertAvailability.forEach((_, timeSlot) {
        if (timeSlot['start'] != null || timeSlot['end'] != null) {
          DateTime start = timeSlot['start'].toDate();
          DateTime end = timeSlot['end'].toDate();
          if (now.hour > start.hour && now.hour < end.hour) {
            expertAvailable = true;
          } else if (now.hour == start.hour || now.hour == end.hour) {
            if (now.minute > start.minute && now.minute < start.minute) {
              expertAvailable = true;
            }
          } else {
            expertAvailable = false;
          }
        }
      });
    }

    setState(() {
      checkingAvail = false;
    });
  }

  void contactOnTap({
    @required String secondaryText,
    @required Widget icon,
    @required String serviceType,
  }) async {
    checkingAvail = true;

    if (checkingAvail) {
      bottomSheet.showBottomSheet(
        context: context,
        icon: CircularProgressIndicator(),
        secondaryText: "Checking Availablity",
        callback: null,
      );
    }

    await checkAvail();

    if (expertAvailable) {
      bottomSheet.showBottomSheet(
        context: context,
        icon: icon,
        secondaryText: secondaryText,
        callback: () {
          updateInteraction();
          contactExpert.launchSkype(
              context: context,
              skypeUsername: expert['SkypeUser'],
              serviceType: serviceType,
              afterLaunchFunc: () {});
        },
      );
    } else if (!expertAvailable) {
      bottomSheet.showBottomSheet(
        context: context,
        icon: Icon(Icons.not_interested, size: 120),
        secondaryText: "Expert is not available right now!",
        callback: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            contactOnTap(
                secondaryText: "Are you sure you want to call this expert",
                serviceType: "call",
                icon: Icon(Icons.face, size: 120));
          },
          child: Icon(
            Icons.video_call,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: InkWell(
              onTap: () {
                contactOnTap(
                    secondaryText:
                        "Are you sure you want to message this expert",
                    serviceType: "chat",
                    icon: Icon(Icons.chat_bubble_outline, size: 120));
              },
              child: Icon(Icons.chat, size: 20)),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (
                  BuildContext context,
                ) {
                  return expert_feedback.Feedback(expert);
                }),
              );
            },
            child: Icon(
              Icons.feedback,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
