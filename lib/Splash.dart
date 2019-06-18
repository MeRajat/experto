import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:experto/video_call/notification.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:experto/main.dart';

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
    initNotification();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home_page');
    });
    super.initState();
  }

  Future onSelectNotification(String payload) async {
    MyApp.navigatorKey.currentState.pushNamedAndRemoveUntil(
        "/video_call",
        //(route) => route.settings.name == "/video_call" ? false : true); TODO: why does this not work
        ModalRoute.withName("/user_home"));
//    await Navigator.of(context, rootNavigator: true).push(
//      MaterialPageRoute(
//        builder: (BuildContext context) {
//          return notificationStartVideo;
//        },
//      ),
//    );
  }

  void initNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void getPermissions() async {
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
          child: Hero(
              tag: "logo",
              child: Image.asset("assets/logo_transparent.png",
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Color.fromRGBO(234, 206, 180, 100)
                      : Colors.black)),
        ),
      ),
      // )
    );
  }
}
