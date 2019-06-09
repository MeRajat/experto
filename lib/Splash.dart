import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home_page');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: new Center(
          child:
          Hero(tag: "logo", child:  Icon(CupertinoIcons.book_solid, size: 250)),
        ),
      ),
      // )
    );
  }
}
