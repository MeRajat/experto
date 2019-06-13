import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:url_launcher/url_launcher.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() {
    return new SplashState();
  }
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    //print(MediaQuery.of(context).size.height);
    //print(MediaQuery.of(context).size.width);
    getPermissions();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home_page');
      getSkypeAvailability();
    });
    super.initState();
  }

  void getSkypeAvailability() async {
    try {
      await AppAvailability.checkAvailability("com.skype.raider");
      if(!(await AppAvailability.isAppEnabled("com.skype.raider")))
        _showSkypeDialog();
    } on PlatformException {
      _showSkypeDialog();
    }
  }

  void _showSkypeDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Skype required'),
          content: new Text(
              'This app requires Skype for communication with experts and vice versa.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('OPEN PLAY STORE'),
              onPressed: () {
                try {
                  AppAvailability.checkAvailability("com.android.vending");
                  launch("market://details?id=com.skype.raider");
                } on PlatformException {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        title: new Text("Play Store not found"),
                        content: new Text("Please install Skype manually"),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
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
              },
            )
          ],
        );
      },
    );
  }

  Future<void> getPermissions() async {
    List<PermissionGroup> permission = [
      PermissionGroup.camera,
      PermissionGroup.microphone,
      PermissionGroup.storage
    ];
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(permission);
    /*permission.forEach((PermissionGroup p)async{
      PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(p);
      if(permissionStatus.value==0){
        bool isShown= await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.contacts);
        if(!isShown)
          _ackAlert(context, "Permissions", "The app requires "+p.value.toString()+" permission to function");
      }
    });*/
    permissions.forEach((PermissionGroup pg, PermissionStatus ps) {
      print(pg.toString() + " " + ps.toString() + "\n");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: new Center(
          child:
          Hero(tag: "logo", child:  Image.asset("assets/logo_transparent.png",)),
        ),
      ),
    );
  }
}
