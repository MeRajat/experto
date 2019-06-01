import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import "package:experto/global_app_bar.dart";

class CustomFlexibleSpace extends StatelessWidget {
  final String flexibleSpaceText;

  CustomFlexibleSpace(this.flexibleSpaceText);

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.all(20),
      background: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  flexibleSpaceText,
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

class AppBar extends StatelessWidget {
  final String flexibleSpaceText;

  AppBar(this.flexibleSpaceText);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(250, "Experto", CustomFlexibleSpace(flexibleSpaceText));
  }
}
