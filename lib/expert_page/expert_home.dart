import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import "./expert_home/expert_home.dart";
import "./settings_page/settings_page.dart";
import './navigation_bar_items.dart';
import 'package:experto/global_data.dart';

class HomePage extends StatefulWidget {
  final Data expert;
  HomePage(this.expert);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final List<Widget> pages = [
    ExpertHome(),
    SettingsPage(),
  ];

  int currentIndex = 0;

  final List<GlobalKey<NavigatorState>> keys = [
    GlobalKey(debugLabel: 'expert home page'),
    GlobalKey(debugLabel: 'expert settings page'),
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
      widget.expert,
      Scaffold(
        body: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
              items: navigationBarItems(),
              onTap: (int tapped) {
                currentIndex = tapped;
              }),
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
