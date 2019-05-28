import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import "../user_page/app_bar.dart";

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
                Container(
                  margin: EdgeInsets.only(right: 20),
                  padding:
                      EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                  ),
                  child: Text('Expert',style:Theme.of(context).primaryTextTheme.body2.copyWith(color:Colors.black)),
                )
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
