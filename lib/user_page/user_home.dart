import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import "./search_skill/search_skill.dart";
import "./search_expert/search_expert.dart";
import "./user_home/user_home.dart";
import "./settings_page/settings_page.dart";
import "./navigation_bar_items.dart";
import 'package:experto/global_data.dart';



class HomePage extends StatefulWidget {
  final Data user;
  
  HomePage(this.user);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final List<Widget> pages = [
    UserHome(),
    SearchSkill(),
    SearchExpert(),
    SettingsPage(),
  ];

  int currentIndex = 0;

  final List<GlobalKey<NavigatorState>> keys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];

  Future<bool> overrideBack() {
    NavigatorState navigator = keys[currentIndex].currentState;
    bool canPop = navigator.canPop();
    if (canPop) {
      navigator.pop();
    }
    return Future.value(!canPop);
  }

  @override
  Widget build(BuildContext context) {
    return DocumentSync(
      widget.user,
      Scaffold(
        body: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: navigationBarItems(),
            onTap: (int tapped){
              currentIndex = tapped;
            }
          ),
          tabBuilder: (BuildContext context, int index) {
            return WillPopScope(
              onWillPop: () => overrideBack(),
              child: CupertinoTabView(
                navigatorKey: keys[index],
                builder: (context) {
                  return pages[index];
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
