import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "./expert_home/expert_home.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final List<Widget> pages = [
    ExpertHome(),
    //SearchSkill(),
    //SearchExpert(),
    //FeedBack(),
  ];

  final List<GlobalKey<NavigatorState>> keys = [
    GlobalKey(debugLabel: 'expert home page'),
    //GlobalKey(debugLabel: 'expert skill page'),
    //GlobalKey(debugLabel: 'expert page'),
    //GlobalKey(debugLabel: 'feedback page'),
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
    return Scaffold(
      //tabBar: CupertinoTabBar(
      //  items: navigationBarItems(),
      //),
      body: pages[0],
    );
  }
}
