import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notez/constants/firestore_constants.dart';
import 'package:notez/pages/pages.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:provider/provider.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging();
  final authProv = AuthenticationProvider();

  Future initialize(context) async {
    if (Platform.isIOS) {
      //request Permissions from Ios Users
      fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    fcm.configure(
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

    fcm.onTokenRefresh.listen((String token) async {
      Provider.of<AuthenticationProvider>(context).token = token;
      if (Provider.of<AuthenticationProvider>(context).currentUsercheck()) {
        Provider.of<AuthenticationProvider>(context).updateToken(token);
      }
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
