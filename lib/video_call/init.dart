<<<<<<< HEAD
//import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
/*import io.agora.rtc.Constants;
import io.agora.rtc.IRtcEngineEventHandler;
import io.agora.rtc.RtcEngine;
...*/

class Agora extends StatefulWidget{
  @override
  _AgoraState createState() => _AgoraState();
}

class _AgoraState extends State<Agora> {

  @override
  void initState(){
    super.initState();
    //_initAgoraRtcEngine();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
=======
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
>>>>>>> 52f85a5ec5ddc0f3ac2569d40fdb99e03ffb4580
