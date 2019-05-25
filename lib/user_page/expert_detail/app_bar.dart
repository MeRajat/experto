import 'package:flutter/material.dart';
import "package:flutter/cupertino.dart";

import "../app_bar.dart";

class AppBar extends StatelessWidget {
  final String expertName;

  AppBar(this.expertName);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      250,
      'Detail',
      CustomFlexibleSpaceBar(expertName),
    );
  }
}

class CustomFlexibleSpaceBar extends StatelessWidget {
  final String expertName;

  CustomFlexibleSpaceBar(this.expertName);

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.all(0),
      background: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10, top: 80),
            child: Icon(
              Icons.person,
              size: 110,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  expertName,
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: -.5,
                      ),
                ),
                Text(
                  "something@gmail.com",
                  style: Theme.of(context).primaryTextTheme.body1.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
