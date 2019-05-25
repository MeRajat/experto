import "package:flutter/material.dart";

import './app_bar.dart' as home_page_appbar;
import './cards.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          home_page_appbar.AppBar(),
          Cards(),
        ],
      ),
    );
  }
}
