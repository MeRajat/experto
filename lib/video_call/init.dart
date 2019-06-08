import 'package:experto/user_authentication/userAdd.dart';
import 'package:experto/utils/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

class StartVideo extends StatefulWidget {
  @override
  _StartVideoState createState() => _StartVideoState();
}

class _StartVideoState extends State<StartVideo> {
  bool _isInChannel = false, _toggleView = true;
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

    // Local Notification
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _toggleChannel();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      body: Center(
        child: Stack(
          children: _viewRows() +
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        setState(() {
                          speaker = !speaker;
                        });
                        await AgoraRtcEngine.setEnableSpeakerphone(!speaker);
                        print(speaker);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: speaker ? Theme.of(context).buttonColor : null,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.speaker_phone),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          mic = !mic;
                        });
                        AgoraRtcEngine.enableLocalAudio(mic);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          //color: mic ? null : Theme.of(context).buttonColor,
                          shape: BoxShape.circle,
                        ),
                        child: mic?Icon(Icons.mic):Icon(Icons.mic_off),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          camera = !camera;
                        });
                        AgoraRtcEngine.switchCamera();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          //color: mic ? null : Theme.of(context).buttonColor,
                          shape: BoxShape.circle,
                        ),
                        child: camera
                            ? Icon(Icons.camera_rear)
                            : Icon(Icons.camera_front),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _toggleChannel();
                        startVideo = null;
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.call_end),
                      ),
                    )
                  ],
                ),
              ],
          //Container(height: 592, child: _viewRows()),
          //Container(height: 150,width: 110,padding: EdgeInsets.only(right: 20,bottom: 20), child: _viewRows(2)),
          alignment: AlignmentDirectional.bottomEnd,
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //floatingActionButton: FloatingActionButton(
      //  onPressed: () {
      //    _toggleChannel();
      //    startVideo = null;
      //    Navigator.of(context).pop();
      //  },
      //  child: Icon(Icons.call_end),
      //  backgroundColor: Colors.red,
      //),
      // bottomNavigationBar: Container(
      //   color: Colors.transparent,
      //   //color: Theme.of(context).bottomAppBarColor,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: <Widget>[
      //       FlatButton(
      //         onPressed: () async {
      //           setState(() {
      //             speaker = !speaker;
      //           });
      //           await AgoraRtcEngine.setEnableSpeakerphone(!speaker);
      //           print(speaker);
      //         },
      //         child: Icon(Icons.speaker_phone),
      //         color: speaker ? Theme.of(context).buttonColor : null,
      //       ),
      //       FlatButton(
      //         onPressed: () {
      //           setState(() {
      //             mic = !mic;
      //           });
      //           AgoraRtcEngine.enableLocalAudio(mic);
      //         },
      //         child: Icon(Icons.mic_off),
      //         color: mic ? null : Theme.of(context).buttonColor,
      //       ),
      //       FlatButton(
      //         onPressed: () {
      //           setState(() {
      //             camera = !camera;
      //           });
      //           AgoraRtcEngine.switchCamera();
      //         },
      //         child:
      //             camera ? Icon(Icons.camera_rear) : Icon(Icons.camera_front),
      //       )
      //     ],
      //   ),
      // ),
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
      await flutterLocalNotificationsPlugin.cancelAll();
      _isInChannel = false;
      AgoraRtcEngine.leaveChannel();
      AgoraRtcEngine.stopPreview();
    } else {
      _isInChannel = true;
      _showNotification();
      AgoraRtcEngine.startPreview();
      bool status = await AgoraRtcEngine.joinChannel(null, "notdemo", null,
          int.parse(UserData.currentUser["Mobile"].toString().substring(2)));
      print(status);
    }
    setState(() {});
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'VideoCall',
        'Video Calls',
        'The ongoing notifcation that shows the current;y elapsed time of the video call',
        importance: Importance.Low,
        priority: Priority.Low,
        ongoing: true,
        autoCancel: false);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    var clock = Stopwatch();
    clock.start();
    while (true) {
      await Future.delayed(Duration(seconds: 1), () async {});
      if (!_isInChannel) return;
      String twoDigits(int n) {
        if (n >= 10) return "$n";
        return "0$n";
      }

      String twoDigitMinutes = twoDigits(clock.elapsed.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(clock.elapsed.inSeconds.remainder(60));
      String twoDigitHours = twoDigits(clock.elapsed.inHours);
      await flutterLocalNotificationsPlugin.show(
          0,
          'Video Call',
          "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds",
          platformChannelSpecifics);
    }
  }

  List<Widget> _viewRows() {
    List<Widget> views = _getRenderViews();
    List<Widget> expandedViews = new List<Widget>();
    if (views.length >= 2) {
      if (_toggleView) {
        expandedViews.add(
            Container(height: 592, width: 400, child: views[views.length - 1]));
        expandedViews.add(
          Stack(
            children: <Widget>[
              Container(
                  height: 150,
                  width: 110,
                  padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
                  child: views[views.length - 2]),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _toggleView = !_toggleView;
                  });
                },
                child: SizedBox(
                  height: 130,
                  width: 60,
                ),
              )
            ],
          ),
        );
      } else {
        expandedViews.add(
            Container(height: 592, width: 400, child: views[views.length - 2]));
        expandedViews.add(Stack(
          children: <Widget>[
            Container(
                height: 150,
                width: 110,
                padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
                child: views[views.length - 1]),
            FlatButton(
              onPressed: () {
                setState(() {
                  _toggleView = !_toggleView;
                });
              },
              child: SizedBox(
                height: 130,
                width: 60,
              ),
            )
          ],
        ));
      }
      return expandedViews;
    } else if (views.length != 0) {
      expandedViews.add(
          Container(height: 592, width: 400, child: views[views.length - 1]));
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
