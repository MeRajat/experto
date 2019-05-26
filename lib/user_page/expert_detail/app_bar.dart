import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:flutter/cupertino.dart";

import "package:url_launcher/url_launcher.dart";
import "../app_bar.dart";

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
          Padding(
            padding: EdgeInsets.only(left: 10, top: 80),
            child: Hero(
              tag: expert["emailID"],
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
                  child: ContactExpert("s.ganjoo96"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactExpert extends StatelessWidget {
  final String expertSkypeUsername;

  ContactExpert(this.expertSkypeUsername);

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
      await launch(url);
    } else {
      _showDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            _launchSkype(context, expertSkypeUsername, "call");
          },
          child: Icon(Icons.video_call),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: () {
              _launchSkype(context, expertSkypeUsername, "chat");
            },
            child: Icon(Icons.chat),
          ),
        ),
      ],
    );
  }
}
