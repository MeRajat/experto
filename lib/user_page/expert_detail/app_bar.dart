import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:experto/utils/bloc/reload.dart";
import 'package:experto/global_data.dart';
import 'package:experto/utils/bloc/syncDocuments.dart';

import 'package:experto/utils/bottomSheet.dart' as bottomSheet;
import 'package:experto/utils/contact_expert.dart' as contactExpert;
import 'package:experto/utils/placeholder.dart';

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
              child: (expert["profilePicThumb"] == null)
                  ? Icon(
                Icons.person,
                size: 110,
              )
                  : CachedNetworkImage(
                imageBuilder: (context, imageProvider) => Container(
                  margin: EdgeInsets.only(left: 10, right: 5),
                  width: 90.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[400],
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                imageUrl: expert["profilePicThumb"],
                height: 110,
                width: 110,
                placeholder: (context, a) => Container(
                  margin: EdgeInsets.only(left: 10, right: 5),
                  width: 90,
                  height: 90,
                  child: CustomPlaceholder(),
                ),
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
                    tag: "contact${expert['emailID']}",
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
  Data user;
  CollectionReference interaction;
  @override
  void initState(){
    super.initState();
    checkAvail();
    checkPeriodic();
  }

  checkPeriodic(){
    Future.delayed(Duration(minutes: 10)).then((val)async {
      await checkAvail();
      print("done");
      checkPeriodic();
    });
  }

  @override
  void didChangeDependencies() {
    user = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  _ContactExpert(this.expert) {
    getInteraction();
  }

  void getInteraction() {
    interaction = Firestore.instance.collection("Interactions");
  }

  Future<void> updateInteraction() async {
//    int id;
//    bool interactionAlreadyAvailable = false;
//    QuerySnapshot tempsnap;
//    try {
//      tempsnap = await interaction
//          .where("user", isEqualTo: user.detailsData.documentID)
//          .getDocuments();
//      tempsnap.documents.forEach((document) {
//        if (document["expert"] == expert.documentID) {
//          interactionAlreadyAvailable = true;
//        }
//      });
//      if (!interactionAlreadyAvailable) {
//        tempsnap = null;
//      }
//    } catch (e) {
//      tempsnap = null;
//    }
//
//
//    if (tempsnap != null) {
//      await tempsnap.documents[0].reference.updateData({
//        "interactionTime": FieldValue.arrayUnion([DateTime.now()])
//      });
//    } else {
//      await interaction.add({
//        'expert': expert.documentID,
//        'user': user.detailsData.documentID,
//      });
//    }

    await interaction.add({
      'expert': expert.documentID,
      'user': user.detailsData.documentID,
    });
    Data newUser = Data();
    newUser.profileData = user.profileData;
    newUser.detailsData = await user.detailsData.reference.get();
    syncDocument.updateStatus(newUser);
    userSearchExpert.updateStatus(true);
  }

  Future<void> checkAvail() async {
    setState(() {
      checkingAvail = true;
    });

    expertAvailable = await contactExpert.checkAvail(expert);

    setState(() {
      checkingAvail = false;
    });
  }

  void contactOnTap({
    @required String secondaryText,
    @required Widget icon,
    @required String serviceType,
  }) async {


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
              afterLaunchFunc: () {},
          );
        },
      );
    }
//    else if (!expertAvailable) {
//      bottomSheet.showBottomSheet(
//        context: context,
//        icon: Icon(Icons.not_interested, size: 120),
//        secondaryText: "Expert is not available right now!",
//        callback: null,
//      );
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap:  !expertAvailable?null:() {
            contactOnTap(
                secondaryText: "Are you sure you want to call this expert",
                serviceType: "call",
                icon: Icon(Icons.face, size: 120));
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: checkingAvail?Colors.grey:expertAvailable?Colors.grey[800]:Colors.grey,
            ),
            height: 30,
            width: 30,
            child: Icon(
              Icons.video_call,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: InkWell(
              onTap: !expertAvailable?null:() {
                contactOnTap(
                    secondaryText:
                    "Are you sure you want to message this expert",
                    serviceType: "chat",
                    icon: Icon(Icons.chat_bubble_outline, size: 120));
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: checkingAvail?Colors.grey:expertAvailable?Colors.grey[800]:Colors.grey,
                ),
                height: 30,
                width: 30,
                child: Icon(
                  Icons.chat,
                  color: Colors.white,
                  size: 18,
                ),
              ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: InkWell(
            onTap:  !expertAvailable?null:() {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (
                    BuildContext context,
                    ) {
                  return expert_feedback.Feedback(expert);
                }),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: checkingAvail?Colors.grey:expertAvailable?Colors.grey[800]:Colors.grey,
              ),
              height: 30,
              width: 30,
              child: Icon(
                Icons.feedback,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
