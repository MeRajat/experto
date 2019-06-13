import "package:flutter/material.dart";
import 'package:experto/video_call/init.dart';
import "package:url_launcher/url_launcher.dart";
import 'package:experto/utils/floating_action_button.dart' as floatingButton;

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
  floatingButton.startVideo = StartVideo();
  Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute(
      builder: (BuildContext context) {
        return floatingButton.startVideo;
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
