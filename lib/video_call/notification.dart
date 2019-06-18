import 'package:experto/video_call/init.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

StartVideo notificationStartVideo;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

var _isInCall = false;

void stateChangedInformNotification(isInChannel) {
  _isInCall = isInChannel;
  if (_isInCall) {
    _showNotification();
  } else
    flutterLocalNotificationsPlugin.cancelAll();
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
    if (!_isInCall) {
      return;
    }
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
