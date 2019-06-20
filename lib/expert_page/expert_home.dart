import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import "./expert_home/expert_home.dart";
import "./settings_page/settings_page.dart";
import './navigation_bar_items.dart';
import '../expert_authentication/expertData.dart';


class HomePage extends StatefulWidget {
  final ExpertData expert;
  HomePage(this.expert);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final List<Widget> pages = [
    ExpertHome(),
    SettingsPage(),
  ];

  final List<GlobalKey<NavigatorState>> keys = [
    GlobalKey(debugLabel: 'expert home page'),
    GlobalKey(debugLabel: 'expert settings page'),
  ];

  Future<bool> overrideBack(index) {
    NavigatorState navigator = keys[index].currentState;
    bool canPop = navigator.canPop();
    if (canPop) {
      navigator.pop();
    }
    return Future.value(!canPop);
  }

  @override
  Widget build(BuildContext context) {
    return ExpertDocumentSync(
      widget.expert,
      Scaffold(
        body: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: navigationBarItems(),
          ),
          tabBuilder: (BuildContext context, int index) {
            return WillPopScope(
              onWillPop: () => overrideBack(index),
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
