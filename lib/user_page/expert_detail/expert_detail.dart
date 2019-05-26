import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import './app_bar.dart' as accountAppBar;
import './details.dart';

class ExpertDetail extends StatelessWidget {
  final DocumentSnapshot expert;
  ExpertDetail(this.expert);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          accountAppBar.AppBar(expert),
          Detail(expert: expert),
        ],
      ),
    );
  }
}
