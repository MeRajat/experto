import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:experto/user_authentication/signUpReq.dart' as user;
import 'package:experto/expert_authentication/signUpReq.dart' as expert;

class Splash extends StatefulWidget {
  @override
  SplashState createState() {
    return new SplashState();
  }
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    startUp();
  }

  Future<void> startUp()async{
    await Future.wait([
      getPermissions(),
      Future.delayed(Duration(seconds: 1)),
    ]);
    await autoLogin();
    getSkypeAvailability();
  }

  Future<void> autoLogin() async {
    final user.Authenticate authenticateUser = new user.Authenticate();
    final expert.Authenticate authenticateExpert = new expert.Authenticate();
    final pref = await SharedPreferences.getInstance();
    if (pref.getString("account_type") == null) {
      Navigator.of(context).pushReplacementNamed('/home_page');
    } else {
      pref.getString("account_type") == "user"
          ? await authenticateUser.isSignIn(context)
          : await authenticateExpert.isSignIn(context);
    }
  }

  Future<void> getSkypeAvailability() async {
    try {
      await AppAvailability.checkAvailability("com.skype.raider");
      if (!(await AppAvailability.isAppEnabled("com.skype.raider")))
        await _showSkypeDialog();
    } on PlatformException {
      await _showSkypeDialog();
    }
  }

  Future<void> _showSkypeDialog() async {
    showDialog(
      barrierDismissible: false,
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
              child: const Text('OPEN APP STORE'),
              onPressed: () {
                try {
                  launch("market://details?id=com.skype.raider");
                } on PlatformException {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("Could not open App Store"),
                        content: new Text("Please install Skype manually"),
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
              },
            )

          ],
        );
      },
    );
  }

  Future<void> getPermissions() async {
    List<PermissionGroup> permission = [
//      PermissionGroup.camera,
//      PermissionGroup.microphone,
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Hero(
            tag: "logo",
            child: Image.asset(
              "assets/logo_transparent.png",
            ),
          ),
        ),
      ),
    );
  }
}
