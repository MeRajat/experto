import 'package:experto/global_data.dart';
import "package:flutter/material.dart";
import 'package:cached_network_image/cached_network_image.dart';
import "package:experto/utils/global_app_bar.dart";
import './settings.dart';

class CustomFlexibleSpaceBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Data expert = DocumentSync.of(context).account;
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.all(0),
      background: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, top: 80),
            child: Hero(
              tag: "profilePic",
              child: expert.profileData.photoUrl == null ? Icon(
                Icons.person,
                size: 110,
              ) : CachedNetworkImage(
                imageBuilder: (context, imageProvider) =>
                    Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                imageUrl: expert.profileData.photoUrl,
                height: 110, width: 110,
                placeholder: (context, a) => CircularProgressIndicator(),
              ),
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
                    expert.profileData.displayName,
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
                    expert.profileData.email,
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
