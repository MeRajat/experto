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
  int currentIndex = 0;

  final List<NavigatorObserver> observers = List.generate(2,(_)=>NavigatorObserver());

  final List<HeroController> heroControllers = List.generate(2,(_)=>HeroController());

  final List<Widget> pages = [
    ExpertHome(),
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
      widget.expert,
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
      ),
    );
  }
}
