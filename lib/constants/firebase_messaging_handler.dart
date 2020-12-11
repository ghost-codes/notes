import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notez/constants/firestore_constants.dart';
import 'package:notez/pages/pages.dart';
import 'package:notez/providers/authenticationProvider.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final authProv = AuthenticationProvider();

  Future initialize(context, String uid) async {
    if (Platform.isIOS) {
      //request Permissions from Ios Users
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.onTokenRefresh.listen((token) async {
      await userRef.doc(uid).update({'token': token});
    });
    _fcm.configure(
        //Called when App is in foreground
        onMessage: (Map<String, dynamic> message) async {
      print("onMessage:$message");
      authProv.setSharedNoteNotificaiton("");
    },

        //Called when App is completely closed
        onLaunch: (Map<String, dynamic> message) async {
      print("onMessage:$message");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SharedNotes()));
    },

        //Called when app is in the background and not completely closed
        onResume: (Map<String, dynamic> message) async {
      print("onMessage:$message");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SharedNotes()));
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
