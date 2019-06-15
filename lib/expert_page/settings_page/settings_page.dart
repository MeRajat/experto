import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

import "package:experto/utils/global_app_bar.dart";
import './settings.dart';
import 'package:experto/expert_page/expert_home.dart';

class CustomFlexibleSpaceBar extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {

    DocumentSnapshot expert = ExpertDocumentSync.of(context).expert;
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.all(0),
      background: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                Container(
                  width: 200,
                  child: Text(
                    expert["Name"],
                    style: Theme.of(context).textTheme.title.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: -.5,
                        ),
                  ),
                ),
                Container(
                  width: 200,
                  child: Text(
                    expert["emailID"],
                    style: Theme.of(context).primaryTextTheme.body1.copyWith(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
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

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        CustomAppBar(
          250,
          "Settings",
          CustomFlexibleSpaceBar(),
        ),
        SliverPadding(
          padding: EdgeInsets.all(10),
        ),
        SettingsTiles(),
        SliverPadding(
          padding: EdgeInsets.all(60),
        ),
      ],
    );
  }
}
