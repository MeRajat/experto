import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import './app_bar.dart' as accountAppBar;
import './details.dart';

class ExpertDetail extends StatelessWidget {
  final String expertName;
  ExpertDetail(this.expertName);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          accountAppBar.AppBar(expertName),
          Detail(),
        ],
      ),
    );
  }
}
