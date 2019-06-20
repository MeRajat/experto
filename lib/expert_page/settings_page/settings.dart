import 'package:experto/expert_page/settings_page/profilePic.dart';
import 'package:experto/utils/authentication_page_utils.dart';
import "package:firebase_auth/firebase_auth.dart";

import 'package:experto/home_page/home_page.dart';
import 'package:experto/expert_page/settings_page/name.dart';
import "package:flutter/material.dart";
import "./availabity_page.dart";

class SettingsTiles extends StatelessWidget {
  final List<List> tiles = [
    [Icon(Icons.image), "Profile Picture", ProfilePicUpdate()],
    [Icon(Icons.enhanced_encryption), "Password", Password()],
    [Icon(Icons.email), "Email", Email()],
    [Icon(Icons.video_call), "Skype Username", Container()],
    [Icon(Icons.av_timer), "Availabality", Container()],
    [Icon(Icons.delete_forever), "Delete Account", DeleteAccount()],
    [Icon(Icons.exit_to_app), "Logout",null],
  ];

  void logOut(BuildContext context) async {

    showAuthSnackBar(
      context: context,
      title: "Logging Out...",
      leading: CircularProgressIndicator(),
    );
    await Future.delayed(Duration(seconds: 2));
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (buildContext) => HomePage()),
          ModalRoute.withName(':'));
    } catch (e) {
      showAuthSnackBar(
        context: context,
        title: "Error...",
        leading: Icon(Icons.error, size: 23, color: Colors.green),
      );
    }
  }

  void navigateToSetting(BuildContext context, Widget page) {
    Navigator.of(context, rootNavigator: false).push(
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Hero(
            tag: "setting" + tiles[index][1],
            child: ListTile(
              leading: tiles[index][0],
              title: Text(
                tiles[index][1],
                style: Theme.of(context).primaryTextTheme.body1,
              ),
              onTap: () {
                if (tiles[index][1] == 'Logout') {
                  logOut(context);
                } else {
                  navigateToSetting(context, tiles[index][2]);
                }
              },
            ),
          );
        },
        childCount: tiles.length,
      ),
    );
  }
}
