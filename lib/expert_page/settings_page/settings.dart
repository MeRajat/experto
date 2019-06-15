import "package:flutter/material.dart";
import "./availabity_page.dart";

class SettingsTiles extends StatelessWidget {
  final List<List> tiles = [
    [Icon(Icons.image), "Profile Picture", Container()],
    [Icon(Icons.short_text), "Username", Container()],
    [Icon(Icons.enhanced_encryption), "Password", Container()],
    [Icon(Icons.email), "Email", Container()],
    [Icon(Icons.video_call), "Skype Username", Container()],
    [Icon(Icons.av_timer), "Availablity", Availablity()],
    [Icon(Icons.exit_to_app), "Logout", Container()],
  ];

  void navigateToSetting(BuildContext context, Widget page) {
    Navigator.of(context).push(
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
          return ListTile(
            leading: tiles[index][0],
            title: Text(
              tiles[index][1],
              style: Theme.of(context).primaryTextTheme.body1,
            ),
            onTap: () {
              navigateToSetting(context, tiles[index][2]);
            },
          );
        },
        childCount: tiles.length,
      ),
    );
  }
}
