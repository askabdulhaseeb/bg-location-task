import 'dart:async';
import 'dart:developer';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:location_task/local_db.dart';

Future<void> initService() async {
  await LocalDB.init();
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: startService,
      isForegroundMode: true,
    ),
  );
  await service.startService();
}

@pragma('vm-entry-point')
Future<void> startService(ServiceInstance ser) async {
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

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (ser is AndroidServiceInstance) {
      if (await ser.isForegroundService()) {
        final int count = await LocalDB.count() ?? 0;
        await LocalDB.setCount(count + 1);
        log('message from foreground service');
      }
    }
  });
}
