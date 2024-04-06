import 'dart:async';
import 'dart:developer';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_task/http_call.dart';

const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

Future<void> initService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      onBackground: (service) async => await startService(service),
      onForeground: (service) async => await startService(service),
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: startService,
      isForegroundMode: true,
      autoStart: true,
    ),
  );
  await service.startService();
}

@pragma('vm-entry-point')
Future<dynamic> startService(ServiceInstance ser) async {
  if (ser is AndroidServiceInstance) {
    ser.on('setAsForeground').listen((event) async {
      await ser.setAsForegroundService();
    });
    ser.on('setAsBackground').listen((event) async {
      await ser.setAsBackgroundService();
    });
    ser.on('stopService').listen((event) async {
      await ser.stopSelf();
    });
  }
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (ser is AndroidServiceInstance) {
      if (await ser.isForegroundService()) {
        log('message from foreground service: isForegroundService');
      }
    }
    final Position? position = await HttpCall().updateLocation();
    flutterLocalNotificationsPlugin.show(
      notificationId,
      'COOL SERVICE',
      'Awesome ${DateTime.now()}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'MY FOREGROUND SERVICE',
          channelDescription:
              'Position: ${position?.latitude}, ${position?.longitude}',
          icon: 'ic_bg_service_small',
          ongoing: true,
        ),
      ),
    );
  });
}
