import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TimedOut extends StatelessWidget {
  final double iconSize;
  final String text;
  final Function retry;

  TimedOut(this.retry,
      {this.iconSize: 200, this.text: "Your search timed out"});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.timer,
            size: iconSize,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                text,
                style: Theme.of(context)
                    .primaryTextTheme
                    .body2
                    .copyWith(fontSize: 15),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap:retry,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  "Retry",
                  style: Theme.of(context).primaryTextTheme.body2.copyWith(
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
