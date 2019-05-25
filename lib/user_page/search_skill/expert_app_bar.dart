import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../app_bar.dart';

class CustomFlexibleSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      titlePadding: EdgeInsets.only(left: 0, bottom: 20),
      background: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              bottom: 30,
            ),
            child: Text(
              "Our Experts",
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 31,
                    letterSpacing: -1.2,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class Appbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(250,"Skill",CustomFlexibleSpace());
  }
}
