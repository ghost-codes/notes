import 'package:get_it/get_it.dart';
import 'package:notez/constants/firebase_messaging_handler.dart';

GetIt sl = GetIt.instance;

void setup() {
  sl.registerLazySingleton<PushNotificationService>(
      () => PushNotificationService());
}
