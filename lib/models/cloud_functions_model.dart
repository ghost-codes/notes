import 'package:cloud_functions/cloud_functions.dart';

FirebaseFunctions functions = FirebaseFunctions.instance;

Future<void> shareNotePushNotification(Map<String, dynamic> data) {
  HttpsCallable pushNotificaiton =
      functions.httpsCallable('sharedNotePushNotification');
  final result = pushNotificaiton(data);
  print(result);
}
