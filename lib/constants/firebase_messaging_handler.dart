import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialize() async {
    if (Platform.isIOS) {
      //request Permissions from Ios Users
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
        //Called when App is in foreground
        onMessage: (Map<String, dynamic> message) async {
      print("onMessage:$message");
    },

        //Called when App is completely closed
        onLaunch: (Map<String, dynamic> message) async {
      print("onMessage:$message");
    },

        //Called when app is in the background and not completely closed
        onResume: (Map<String, dynamic> message) async {
      print("onMessage:$message");
    });
  }
}

// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   if (message.containsKey('data')) {
//     // Handle data message
//     final dynamic data = message['data'];
//   }

//   if (message.containsKey('notification')) {
//     // Handle notification message
//     final dynamic notification = message['notification'];
//   }

//   // Or do other work.
// }
