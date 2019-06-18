import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

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
