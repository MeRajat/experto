import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TimedOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.only(top:90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.timer,
            size: 200,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding:EdgeInsets.only(top:20),
              child:Text(
              "Your search timed out",
              style: Theme.of(context)
                  .primaryTextTheme
                  .body2
                  .copyWith(fontSize: 15),
            ),
          ),)
        ],
      ),
    );
  }
}
