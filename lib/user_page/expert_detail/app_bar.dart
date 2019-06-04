import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/user_authentication/userAdd.dart';
import "package:experto/utils/bloc/reload.dart";
import 'package:experto/video_call/init.dart';
import 'package:flutter/material.dart';
import "package:flutter/cupertino.dart";

import "package:url_launcher/url_launcher.dart";
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
                Text(
                  expert["Name"],
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: -.5,
                      ),
                ),
                Text(
                  expert["emailID"],
                  style: Theme.of(context).primaryTextTheme.body1.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: ContactExpert(expert),
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
  final DocumentSnapshot expert;
  CollectionReference interaction;

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
      for (int i = 0; i < currentUser["interactionID"].length; i++) {
        tempsnap = await interaction
            .where("id", isEqualTo: currentUser["interactionID"][i])
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
        await temp.document(currentUser.documentID).updateData({
          "interactionID": FieldValue.arrayUnion([id])
        });
        print(expert["emailID"]);
        await temp2.document(expert.documentID).updateData({
          "interactionID": FieldValue.arrayUnion([id])
        });
        await interaction.add({
          'expert': expert["emailID"],
          'user': currentUser["emailID"],
          'id': id,
          'interactionTime': FieldValue.arrayUnion([DateTime.now()])
        });
      }
      await temp
          .where("emailID", isEqualTo: currentUser["emailID"])
          .getDocuments()
          .then((QuerySnapshot q) {
        currentUser = q.documents[0];
      });
    });
    userSearchExpert.updateStatus(true);
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Skype Required",
              style: Theme.of(context).primaryTextTheme.title),
          content: new Text(
            "Skype is Required to use this service",
            style: Theme.of(context).primaryTextTheme.body2,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _launchSkype(
      BuildContext context, String skypeUsername, String serviceType) async {
    final url = "skype:$skypeUsername?$serviceType";
    if (await canLaunch(url)) {
      await updateInteraction();
      await launch(url);
    } else {
      _showDialog(context);
    }
  }

  void showBottomSheel(
      {@required String title,
      @required String secondaryText,
      @required Function callback}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 20, bottom: 80),
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 24, letterSpacing: -.5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    bottom: 10,
                  ),
                  child: Text(
                    secondaryText,
                    style: Theme.of(context).primaryTextTheme.body2.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 70,
                  ),
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    child: Text("Yes",
                        style:
                            Theme.of(context).primaryTextTheme.body2.copyWith(
                                  color: Colors.black,
                                )),
                    onPressed: callback,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void videoCall() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return StartVideo();
        },
      ),
    );

    // Navigator.push(
    //  context,
    //  MaterialPageRoute(
    //    builder: (BuildContext context) {
    //      return StartVideo();
    //    },
    //  ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            showBottomSheel(
                title: "video call ${expert["Name"]}",
                secondaryText:
                    "Are you sure you want to video call this expert ?",
                callback: videoCall);
          },
          child: Icon(Icons.video_call),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: () {
              showBottomSheel(
                  title: "message ${expert["Name"]}",
                  secondaryText: "Are you sure you want to message this expert",
                  callback: () {
                    _launchSkype(context, expert["SkyperUser"], "chat");
                  });
            },
            child: Icon(
              Icons.chat,
              size: 20,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
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
