import 'package:flutter/material.dart';
/*

class startVideo extends StatefulWidget{
  @override
  _startVideoState createState() => _startVideoState();
}

class _startVideoState extends State<startVideo> {
  @override
  Widget build(BuildContext context) {
    var =false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Flutter SDK'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(height: 320, child: _viewRows()),
            OutlineButton(
              child: Text(=false ? 'Leave Channel' : 'Join Channel',
                  style: textStyle),
              onPressed: _toggleChannel,
            ),
            Expanded(child: Container(child: _buildInfoList())),
          ],
        ),
      ),
    );
  }

  Widget _viewRows() {
    List<Widget> views = _getRenderViews();
    if (views.length > 0) {
      List<Widget> expandeViews = views
          .map((widget) => Expanded(child: Container(child: widget)))
          .toList();
      return Row(children: expandeViews);
    } else {
      return null;
    }
  }

  List<Widget> _getRenderViews() {
    return _sessions.map((session) => session.view).toList();
  }
}*/