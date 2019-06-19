import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

List<BottomNavigationBarItem> navigationBarItems() {
  return <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(
        CupertinoIcons.home,
        size: 25,
      ),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        CupertinoIcons.settings,
        size: 25,
      ),
      title: Text("Categories"),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        CupertinoIcons.person,
        size: 25,
      ),
      title: Text('Expert'),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        CupertinoIcons.settings,
        size: 25,
      ),
      title: Text("Settings"),
    ),
    //BottomNavigationBarItem(
    //  icon: Icon(
    //    CupertinoIcons.news,
    //    size: 25,
    //  ),
    //  title: Text("Feedback"),
    //)
  ];
}
