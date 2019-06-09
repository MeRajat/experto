import "package:flutter/material.dart";

import "./app_bar.dart";
import "./cards.dart";

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          Appbar(),
          Cards(),
         ],
      ),
    );
  }
}