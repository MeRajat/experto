import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

<<<<<<< HEAD
import "package:experto/utils/global_app_bar.dart";
=======
import "package:experto/global_app_bar.dart";
>>>>>>> 801512c84b2779d50223e307066be87041c592d0

class CustomFlexibleSpace extends StatelessWidget{
  final String flexibleSpaceText;

  CustomFlexibleSpace(this.flexibleSpaceText);
  
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
                    flexibleSpaceText,
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
  final String flexibleSpaceText;

  AppBar(this.flexibleSpaceText);
  
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(250,"Experto",CustomFlexibleSpace(flexibleSpaceText),logout: false,);
  }
}
