import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import './expert_app_bar.dart';
import './expert_cards.dart';

class ExpertList extends StatelessWidget {
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
