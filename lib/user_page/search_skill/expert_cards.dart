import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";


class Cards extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return CircularProgressIndicator();
          },
          childCount: 10,
        ),
      ),
      padding: EdgeInsets.only(top: 20, bottom: 80),
    );
  }
}
