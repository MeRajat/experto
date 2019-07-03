import "package:flutter/material.dart";

void showBottomSheet(
    {@required Widget icon,
    @required String secondaryText,
    @required Function callback,
    @required BuildContext context}) {
  Scaffold.of(context).showBottomSheet((context) {
    return Material(
      elevation: 5,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            child: icon,
            padding: EdgeInsets.only(
              top: 20,
              bottom: 20,
            ),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: (callback == null)
                ? Container()
                : Text(
                    secondaryText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.body2.copyWith(
                          fontSize: 12,
                        ),
                  ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 10,
              left: 15,
              right: 15,
              bottom: 30,
            ),
            child: RaisedButton(
              color: (Theme.of(context).brightness == Brightness.dark)
                  ? Color.fromRGBO(42, 123, 249, 1)
                  : Colors.blue,
              child: Text((callback == null) ? secondaryText : "Yes",
                  style: Theme.of(context).primaryTextTheme.body2),
              onPressed: (callback == null)
                  ? null
                  : () {
                      callback();
                    },
            ),
          ),
        ],
      ),
    );
  });
}
