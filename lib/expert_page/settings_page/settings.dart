import 'package:experto/expert_page/settings_page/profilePic.dart';
import 'package:experto/utils/authentication_page_utils.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:shared_preferences/shared_preferences.dart";

import 'package:experto/home_page/home_page.dart';
import 'package:experto/expert_page/settings_page/name.dart';
import "package:flutter/material.dart";
import "./availabity_page.dart";

class SettingsTiles extends StatelessWidget {
  final List<List> tiles = [
    [Icons.image, "Profile Picture", ProfilePicUpdate()],
    [Icons.enhanced_encryption, "Password", Password()],
    [Icons.email, "Email", Email()],
    [Icons.description, "Description", Description()],
    [Icons.location_city, "City", City()],
    [Icons.work, "Work Experience", WorkExperience()],
    [Icons.video_call, "Skype Username", Skype()],
    [Icons.av_timer, "Availabality", Availablity()],
    [Icons.category,"Skills",Skills()],
    [Icons.delete_forever, "Delete Account", DeleteAccount()],
    [Icons.exit_to_app, "Logout", null],
  ];

  void logOut(BuildContext context) async {
    showAuthSnackBar(
      context: context,
      title: "Logging Out...",
      leading: CircularProgressIndicator(),
    );

    final pref = await SharedPreferences.getInstance();
    await pref.setString("account_type", null);

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
              leading: Icon(tiles[index][0],color:Theme.of(context).accentColor),
              title: Text(
                tiles[index][1],
                style: Theme.of(context).primaryTextTheme.body2.copyWith(fontSize: 15),
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
