import 'package:experto/video_call/init.dart';
import 'package:flutter/material.dart';

StartVideo startVideo;

class FAB extends StatefulWidget {
  final color;

  FAB({this.color = Colors.cyan});

  @override
  _FABState createState() => _FABState();
}

class _FABState extends State<FAB> {
  void initState() {
    //count=cartsnapshot.documents.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (startVideo != null)
      return FloatingActionButton.extended(
        heroTag: "fsdf",
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return startVideo;
              },
            ),
          );
        },
        label: Text("Return"),
        icon: Icon(Icons.call),
        backgroundColor: widget.color,
      );
    else
      return Container(
        height: 0,
        width: 0,
      );
  }
}
