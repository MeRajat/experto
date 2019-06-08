import "package:flutter/material.dart";

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
//    // );
//      appBar: AppBar(
//        leading: Image.asset(
//          "assets/logo_transparent.png",
//          color: Theme
//              .of(context)
//              .brightness == Brightness.dark
//              ? Color.fromRGBO(234, 206, 180, 100)
//              : Colors.black,
//        ),
//        title:Text(
//        "Experto",
//        style: Theme.of(context).textTheme.title.copyWith(letterSpacing: -.7),
//      ),
//        flexibleSpace: FlexibleSpaceBar(
//          titlePadding: EdgeInsets.all(20),
//          background: Column(
//            mainAxisAlignment: MainAxisAlignment.end,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.only(left: 20, bottom: 15),
//                child: Text(
//                  "Welcome",
//                  style: Theme.of(context).textTheme.title,
//                  textScaleFactor: 1.8,
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
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
