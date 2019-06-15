import 'package:experto/utils/floating_action_button.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import "./search_skill/search_skill.dart";
import "./search_expert/search_expert.dart";
import "./user_home/user_home.dart";
import "./settings_page/settings_page.dart";
import "./navigation_bar_items.dart";
import '../user_authentication/userAdd.dart';
import 'package:experto/utils/bloc/syncDocuments.dart';

class UserDocumentSync extends StatefulWidget {
  final Widget child;
  final DocumentSnapshot user;

  UserDocumentSync(this.user, this.child);

  @override
  _UserDocumentSync createState() => _UserDocumentSync();

  static TrueInheritedWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(TrueInheritedWidget);
}

class _UserDocumentSync extends State<UserDocumentSync> {
  DocumentSnapshot user;

  @override
  void initState() {
    user = widget.user;
    syncDocument();
    super.initState();
  }

  void syncDocument() async {
    syncDocumentUser.getStatus.listen((newDocument) {
      setState(() {
        user = newDocument;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TrueInheritedWidget(user, widget.child);
  }
}

class TrueInheritedWidget extends InheritedWidget {
  final DocumentSnapshot user;

  TrueInheritedWidget(this.user, child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePage createState() => _HomePage();
//}

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final List<Widget> pages = [
    UserHome(),
    SearchSkill(),
    SearchExpert(),
    SettingsPage(),
    //FeedBack(),
  ];

  final List<GlobalKey<NavigatorState>> keys = [
    GlobalKey(debugLabel: 'user home page'),
    GlobalKey(debugLabel: 'user skill page'),
    GlobalKey(debugLabel: 'user expert page'),
    GlobalKey(debugLabel: 'user settings page')
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
    return UserDocumentSync(
      currentUser,
      Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: FAB(color: Colors.green),
        ),
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
