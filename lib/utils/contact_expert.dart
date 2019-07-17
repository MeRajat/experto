import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";
import 'package:experto/video_call/init.dart';
import 'package:experto/utils/floating_action_button.dart' as floatingButton;
import 'package:experto/video_call/local_notification.dart';

void _showDialog({@required BuildContext context}) {
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

void videoCall({@required BuildContext context}) {
  notificationStartVideo = floatingButton.startVideo = StartVideo();
  stateChangedInformNotification(true);
  Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute(
      builder: (BuildContext context) {
        return StartVideo();
      },
    ),
  );
}

void launchSkype({
  @required BuildContext context,
  @required String skypeUsername,
  @required String serviceType,
  @required Function afterLaunchFunc,
}) async {
  final url = "skype:$skypeUsername?$serviceType";
  if (await canLaunch(url)) {
    await afterLaunchFunc();
    await launch(url);
  } else {
    _showDialog(context: context);
  }
}

Future<bool> checkAvail(DocumentSnapshot expert) async {
  bool avail = true;
  expert = await expert.reference.get();

  if (expert["Availability Mode"] == 'normal') {
    return await Future.value(expert['Available']);
  } else {
    DateTime now = DateTime.now();
    var expertAvailability = expert["Availablity"];
    expertAvailability.forEach((_, timeSlot) {
      if (timeSlot['start'] != null && timeSlot['end'] != null) {
        DateTime start = timeSlot['start'].toDate();
        DateTime end = timeSlot['end'].toDate();
        if (now.hour > start.hour && now.hour < end.hour) {
          avail = true;
          return;
        } else if (now.hour == start.hour || now.hour == end.hour) {
          if (now.minute >= start.minute && now.minute <= end.minute) {
            avail = true;
            return;
          }
          else{
            avail = false;
          }
        } else {
          avail = false;
        }
      }
    });
    return avail;
  }
}
