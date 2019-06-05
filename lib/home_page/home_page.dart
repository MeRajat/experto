import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';

import "./app_bar.dart";
import "./cards.dart";

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //   body: Stack(
    //     alignment: Alignment.bottomCenter,
    //     children: <Widget>[
    //       PageView(
    //         physics: BouncingScrollPhysics(),
    //         children: <Widget>[
    //           Container(
    //             height: MediaQuery.of(context).size.height,
    //             decoration: BoxDecoration(color: Colors.white),
    //           ),
    //           Container(
    //             height: MediaQuery.of(context).size.height,
    //             decoration: BoxDecoration(color: Colors.black),
    //           ),
    //         ],
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           AnimatedContainer(
    //             alignment: Alignment.bottomCenter,
    //             duration: Duration(milliseconds: 500),
    //             margin: EdgeInsets.only(bottom: 20, left: 5, right: 5),
    //             height: 10,
    //             width: 10,
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               color: Colors.blueAccent,
    //             ),
    //           ),
    //           AnimatedContainer(
    //             alignment: Alignment.bottomCenter,
    //             duration: Duration(milliseconds: 500),
    //             margin: EdgeInsets.only(bottom: 20, left: 5, right: 5),
    //             height: 15,
    //             width: 15,
    //             //curve: ElasticOutCurve(),
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               color: Colors.blueAccent,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );

      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          Appbar(),
          Cards(),
         ],
      ),
    );
  }
}
