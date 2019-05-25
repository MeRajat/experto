import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import "../user_page/app_bar.dart";

class CustomFlexibleSpace extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(20),
        background: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, bottom: 15),
              child: Row(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: Theme.of(context).textTheme.title,
                    textScaleFactor: 1.8,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(250,"Experto",CustomFlexibleSpace());
  }
}
