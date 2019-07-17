import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import "./search_skill/search_skill.dart";
import "./search_expert/search_expert.dart";
import "./user_home/user_home.dart";
import "./settings_page/settings_page.dart";
import "./navigation_bar_items.dart";
import 'package:experto/global_data.dart';
import 'package:experto/utils/floating_action_button.dart';

class HomePage extends StatefulWidget {
  final Data user;

  HomePage(this.user);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int currentIndex = 0;

  final List<NavigatorObserver> observers = List.generate(4,(_)=>NavigatorObserver());

  final List<HeroController> heroControllers = List.generate(4,(_)=>HeroController());

  final List<Widget> pages = [
    UserHome(),
    SearchSkill(),
    SearchExpert(),
    SettingsPage(),
  ];

  Future<bool> overrideBack() {
    bool canPop = observers[currentIndex].navigator.canPop();
    if (canPop) {
      observers[currentIndex].navigator.pop();
    }
    return Future.value(!canPop);
  }

  @override
  Widget build(BuildContext context) {
    return DocumentSync(
      widget.user,
      Scaffold(
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: Theme.of(context).appBarTheme.color),
          child: BottomNavigationBar(
            items: navigationBarItems(),
            currentIndex: currentIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey[400],
            selectedFontSize: 11,
            unselectedFontSize: 11,
            onTap: (int tapped) {
              setState(() {
                currentIndex = tapped;
              });
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: overrideBack,
          child: IndexedStack(
            index: currentIndex,
            children: List<Widget>.generate(
              pages.length,
              (int index) => Navigator(
                    observers: [observers[index],heroControllers[index]],
                    onGenerateRoute: (RouteSettings settings) {
                      return MaterialPageRoute(
                        builder: (BuildContext context) => pages[index],
                        settings: settings,
                      );
                    },
                  ),
            ),
          ),
        ),
        floatingActionButton: FAB(),
      ),
    );
  }
}
