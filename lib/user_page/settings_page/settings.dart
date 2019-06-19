import 'package:experto/user_page/settings_page/profilePic.dart';
import "package:firebase_auth/firebase_auth.dart";

import 'package:experto/home_page/home_page.dart';
import 'package:experto/user_page/settings_page/name.dart';
import "package:flutter/material.dart";

class SettingsTiles extends StatelessWidget {
  final List<List> tiles = [
    [Icon(Icons.image), "Profile Picture", ProfilePicUpdate()],
    [Icon(Icons.short_text), "Name", Name()],
    [Icon(Icons.enhanced_encryption), "Password", Passowrd()],
    [Icon(Icons.email), "Email", Email()],
    [Icon(Icons.delete_forever), "Delete Account", DeleteAccount()],
    [Icon(Icons.exit_to_app), "Logout", Container()],
  ];

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (buildContext) => HomePage()),
        ModalRoute.withName(':'));
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
                  logout(context);
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
