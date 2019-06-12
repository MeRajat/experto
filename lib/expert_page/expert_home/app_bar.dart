import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

<<<<<<< HEAD
import "package:experto/utils/global_app_bar.dart";
=======
import "package:experto/global_app_bar.dart";
>>>>>>> 801512c84b2779d50223e307066be87041c592d0

class CuostomFlexibleSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      titlePadding: EdgeInsets.only(left: 0, bottom: 20),
      background: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              bottom: 30,
            ),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Interactions",
                  style: Theme.of(context).textTheme.title,
                  textScaleFactor: 1.8,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
                  child: Icon(Icons.star,color: Color.fromRGBO(84, 229, 121, 1),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Appbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      250,
      "Home Page",
      CuostomFlexibleSpace(),
    );
  }
}
