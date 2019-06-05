import 'package:experto/user_authentication/userAdd.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class StartVideo extends StatefulWidget {
  @override
  _StartVideoState createState() => _StartVideoState();
}

class _StartVideoState extends State<StartVideo> {
  bool _isInChannel = false;
  final _infoStrings = <String>[];
  bool speaker = true, mic = true, camera = true;
  final _sessions = List<VideoSession>();

  @override
  void initState() {
    super.initState();
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    _addRenderView(0, (viewId) {
      AgoraRtcEngine.setupLocalVideo(viewId, VideoRenderMode.Hidden);
    });
    _toggleChannel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: _viewRows(),
          //Container(height: 592, child: _viewRows()),
          //Container(height: 150,width: 110,padding: EdgeInsets.only(right: 20,bottom: 20), child: _viewRows(2)),
          alignment: AlignmentDirectional.bottomEnd,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleChannel();
          Navigator.of(context).pop();
        },
        child: Icon(Icons.call_end),
        backgroundColor: Colors.red,
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).bottomAppBarColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                setState(() {
                  speaker = !speaker;
                });
                await AgoraRtcEngine.setEnableSpeakerphone(!speaker);
                print(speaker);
              },
              child: Icon(Icons.speaker_phone),
              color: speaker ? Theme.of(context).buttonColor : null,
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  mic = !mic;
                });
                AgoraRtcEngine.enableLocalAudio(mic);
              },
              child: Icon(Icons.mic_off),
              color: mic ? null : Theme.of(context).buttonColor,
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  camera = !camera;
                });
                AgoraRtcEngine.switchCamera();
              },
              child:
                  camera ? Icon(Icons.camera_rear) : Icon(Icons.camera_front),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create('b3a6eb25d854422baf608d1010d93463');
    AgoraRtcEngine.enableVideo();
    AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        String info = 'userJoined: ' + uid.toString();
        _infoStrings.add(info);
        _addRenderView(uid, (viewId) {
          AgoraRtcEngine.setupRemoteVideo(viewId, VideoRenderMode.Hidden, uid);
        });
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        String info = 'userOffline: ' + uid.toString();
        _infoStrings.add(info);
        _removeRenderView(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      setState(() {
        String info = 'firstRemoteVideo: ' +
            uid.toString() +
            ' ' +
            width.toString() +
            'x' +
            height.toString();
        _infoStrings.add(info);
      });
    };
  }

  void _toggleChannel() async {
    if (_isInChannel) {
      _isInChannel = false;
      AgoraRtcEngine.leaveChannel();
      AgoraRtcEngine.stopPreview();
    } else {
      _isInChannel = true;
      AgoraRtcEngine.startPreview();
      bool status = await AgoraRtcEngine.joinChannel(null, "demo", null, 2);
      print(status);
    }
    setState(() {});
  }

  List<Widget> _viewRows() {
    List<Widget> views = _getRenderViews();
    List<Widget> expandedViews = new List<Widget>();
    if (views.length >= 2) {
      expandedViews.add(Container(
          height: 592,
          child: Row(
            children: <Widget>[
              Expanded(child: Container(child: views[views.length - 1])),
            ],
          )));
      expandedViews.add(Hero(
        tag:"myvideo",
        child: Container(
            height: 150,
            width: 110,
            padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Container(child: views[views.length - 2])),
              ],
            )),
      ));
      return expandedViews;
    } else if (views.length != 0) {
      expandedViews.add(Hero(
        tag: "myvideo",
        child: Container(
            height: 592,
            child: Row(
              children: <Widget>[
                Expanded(child: Container(child: views[views.length - 1])),
              ],
            )),
      ));
      return expandedViews;
    } else
      return null;
  }

  void _addRenderView(int uid, Function(int viewId) finished) {
    Widget view = AgoraRtcEngine.createNativeView(uid, (viewId) {
      _getVideoSession(uid).viewId = viewId;
      if (finished != null) {
        finished(viewId);
      }
    });
    VideoSession session = VideoSession(uid, view);
    _sessions.add(session);
  }

  void _removeRenderView(int uid) {
    VideoSession session = _getVideoSession(uid);
    if (session != null) {
      _sessions.remove(session);
    }
    AgoraRtcEngine.removeNativeView(session.viewId);
  }

  VideoSession _getVideoSession(int uid) {
    return _sessions.firstWhere((session) {
      return session.uid == uid;
    });
  }

  List<Widget> _getRenderViews() {
    return _sessions.map((session) => session.view).toList();
  }

  static TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.blue);

  Widget _buildInfoList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemExtent: 24,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(_infoStrings[i]),
        );
      },
      itemCount: _infoStrings.length,
    );
  }
}

class VideoSession {
  int uid;
  Widget view;
  int viewId;

  VideoSession(int uid, Widget view) {
    this.uid = uid;
    this.view = view;
  }
}
