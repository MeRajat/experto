import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import "./expert_home/expert_home.dart";
import "./settings_page/settings_page.dart";
import './navigation_bar_items.dart';
import '../expert_authentication/expertData.dart';
import "package:experto/utils/bloc/syncDocuments.dart";

class ExpertDocumentSync extends StatefulWidget{
  final Widget child;
  final DocumentSnapshot expert;

  ExpertDocumentSync(this.expert,this.child);

  @override
  _ExpertDocumentSync createState() => _ExpertDocumentSync();

  static TrueInheritedWidget of(BuildContext context) => context.inheritFromWidgetOfExactType(TrueInheritedWidget);

}

class _ExpertDocumentSync extends State<ExpertDocumentSync>{
  DocumentSnapshot expert;

  @override
  void initState() {
    expert = widget.expert;
    syncDocument();
    super.initState();
  }
  
  void syncDocument() async {
    syncDocumentExpert.getStatusUser.listen((newDocument){
      setState(() {
        expert = newDocument;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return TrueInheritedWidget(expert,widget.child);
  }

}

class TrueInheritedWidget extends InheritedWidget{
  final DocumentSnapshot expert;

  TrueInheritedWidget(this.expert,child):super(child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

class HomePage extends StatefulWidget {
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
      currentExpert,
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
