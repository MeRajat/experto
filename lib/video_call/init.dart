import 'package:async/async.dart';
import 'package:experto/global_data.dart';
import 'package:experto/utils/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:experto/video_call/local_notification.dart';

class StartVideo extends StatefulWidget {
  final Data user;
  StartVideo({@required this.user});
  @override
  _StartVideoState createState() => _StartVideoState(user:user);
}

class _StartVideoState extends State<StartVideo> {
  _StartVideoState({@required this.user});
  final Data user;
  bool _isInChannel = false, _toggleView = true;

  final _infoStrings = <String>[];
  bool speaker = true, mic = false, camera = true, _buttonState = true;
  final _sessions = List<VideoSession>();
  RestartableTimer timer;

  @override
  void initState() {
    super.initState();
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    _addRenderView(0, (viewId) {
      AgoraRtcEngine.setupLocalVideo(viewId, VideoRenderMode.Hidden);
    });
    timer = new RestartableTimer(Duration(seconds: 5), () {
      setState(() {
        _buttonState = !_buttonState;
      });
    });
    _toggleChannel();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: _viewRows() +
            [
              _buttonState
                  ? Positioned(
                      child: FlatButton(
                          shape: CircleBorder(),
                          onPressed: () {
//                            AgoraRtcEngine.disableVideo();
//                            AgoraRtcEngine.stopPreview();
                            Navigator.of(context).pop();
                          },
                          color: Color.fromARGB(100, 255, 227, 242),
                          child: Icon(Icons.keyboard_arrow_down)),
                      top: 35.0,
                      left: -10.0,
                    )
                  : SizedBox()
            ],
        alignment: AlignmentDirectional.bottomEnd,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buttonState
          ? FloatingActionButton(
        heroTag: "ad",
              onPressed: () {
                timer.reset();
                _toggleChannel();
                notificationStartVideo = startVideo = null;
                Navigator.of(context).pop();
//                stateChangedInformNotification(false);
              },
              child: Icon(Icons.call_end),
              backgroundColor: Colors.red,
            )
          : null,
      extendBody: true,
      bottomNavigationBar: _buttonState
          ? Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _bottomButton(Icons.speaker_phone, speaker, () async {
                    setState(() {
                      speaker = !speaker;
                    });
                    AgoraRtcEngine.setEnableSpeakerphone(speaker);
                  }),
                  _bottomButton(Icons.mic_off, mic, () async {
                    setState(() {
                      mic = !mic;
                    });
                    AgoraRtcEngine.enableLocalAudio(!mic);
                  }),
                  _bottomButton(
                      camera ? Icons.camera_rear : Icons.camera_front, false,
                      () async {
                    setState(() {
                      camera = !camera;
                    });
                    AgoraRtcEngine.switchCamera();
                  }),
                ],
              ),
            )
          : null,
    );
  }

  Widget _bottomButton(IconData icon, bool highlight, Function func) {
    return FlatButton(
      shape: CircleBorder(),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      onPressed: () {
        func();
        timer.reset();
      },
      child: Icon(icon),
      color: highlight ? Colors.blue[100] : Color.fromARGB(100, 255, 227, 242),
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
      bool status = await AgoraRtcEngine.joinChannel(null, "demo", null,
          5);
      print(status);
    }
    setState(() {});
  }

  List<Widget> _viewRows() {
    List<Widget> views = _getRenderViews();
    List<Widget> expandedViews = new List<Widget>();
    if (views.length >= 2) {
      expandedViews
          .add(Container(child: views[views.length - (_toggleView ? 1 : 2)]));
      expandedViews.add(InkWell(
        onTap: () {
          timer.reset();
          setState(() {
            _buttonState = !_buttonState;
            if (_buttonState)
              timer.reset();
            else
              timer.cancel();
          });
        },
        onDoubleTap: () async {
          if (_toggleView) return;
          setState(() {
            camera = !camera;
          });
          AgoraRtcEngine.switchCamera();
        },
        child: SizedBox(
          height: 700,
          width: 400,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ));
      expandedViews.add(
        Stack(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(bottom: _buttonState ? 60 : 20, right: 20.0),
              child: Container(
                  height: 150,
                  width: 110,
                  child: views[views.length - (_toggleView ? 2 : 1)]),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _toggleView = !_toggleView;
                });
              },
              onDoubleTap: () async {
                if (!_toggleView) return;
                setState(() {
                  camera = !camera;
                });
                AgoraRtcEngine.switchCamera();
              },
              child: SizedBox(
                height: 130,
                width: 60,
              ),
            )
          ],
        ),
      );
      return expandedViews;
    } else if (views.length != 0) {
      expandedViews.add(Container(
          child: _toggleView
              ? Center(
                  child: Text("Reconnecting..."),
                )
              : views[0]));

      expandedViews.add(InkWell(
        onTap: () {
          timer.reset();
          setState(() {
            _buttonState = !_buttonState;
            if (_buttonState)
              timer.reset();
            else
              timer.cancel();
          });
        },
        onDoubleTap: () async {
          if (_toggleView) return;
          setState(() {
            camera = !camera;
          });
          AgoraRtcEngine.switchCamera();
        },
        child: SizedBox(
          height: 700,
          width: 400,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ));
      expandedViews.add(
        Stack(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    bottom: _buttonState ? 70 : 20.0, right: 20.0),
                child: Container(
                    height: 150,
                    width: 110,
                    color: Colors.white,
                    padding: EdgeInsets.all(0.0),
                    child: _toggleView
                        ? views[0]
                        : Center(
                            child: Text("Reconnecting..."),
                          ))),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _toggleView = !_toggleView;
                });
              },
              onDoubleTap: () async {
                if (!_toggleView) return;
                setState(() {
                  camera = !camera;
                });
                AgoraRtcEngine.switchCamera();
              },
              child: SizedBox(
                height: 130,
                width: 60,
              ),
            )
          ],
        ),
      );
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

//  Widget _buildInfoList() {
//    return ListView.builder(
//      padding: const EdgeInsets.all(8.0),
//      itemExtent: 24,
//      itemBuilder: (context, i) {
//        return ListTile(
//          title: Text(_infoStrings[i]),
//        );
//      },
//      itemCount: _infoStrings.length,
//    );
//  }
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
