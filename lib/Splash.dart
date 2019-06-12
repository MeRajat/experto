import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
    });
    super.initState();
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
<<<<<<< HEAD
          child: Hero(
            tag: "logo",
            child: Image.asset(
              "assets/logo_transparent.png",
            ),
          ),
=======
          child:
          Hero(tag: "logo", child:  Image.asset("assets/logo_transparent.png",color: Color.fromRGBO(234, 206, 180, 100),)),
>>>>>>> 801512c84b2779d50223e307066be87041c592d0
        ),
      ),
    );
  }
}
