import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:steps_counter/screens/home_controller.dart';
import 'package:steps_counter/screens/home_view.dart';
import 'services/google_fit_service.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';


FlutterLocalNotificationsPlugin flutterLocalPlugin =
    FlutterLocalNotificationsPlugin();
AndroidNotificationChannel notificationChannel =
    const AndroidNotificationChannel("FIT", "FIT",
        description: "FIT...", importance: Importance.high);

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  var controller = Get.put(HomeController());

  DartPluginRegistrant.ensureInitialized();

  service.on('setAsForeground').listen((event) {
    print("working -- > setAsForeground");
  });

  service.on('setAsBackground').listen((event) {
    print("working -- > setAsBackground");
    Timer.periodic(
        Duration(seconds: 2), (Timer t) => controller.getTrackingData(isBackground:true));
  });

  service.on("stopService").listen((event) {
    print("working -- > stopService");
    service.stopSelf();
  });

  service.on("onStartBackground").listen((event) {});
}

@pragma('vm:entry-point')
Future<void> backgroudServiseInit() async {
  var service = FlutterBackgroundService();
  await flutterLocalPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);
  await service.configure(
      iosConfiguration: IosConfiguration(
          // onBackground: iosBackground,
          onForeground: onStart),
          androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: false,
          isForegroundMode: true,
          autoStartOnBoot: true,
          notificationChannelId: "FIT",
          initialNotificationTitle: "FIT",
          initialNotificationContent: "Fit is working on background",
          foregroundServiceNotificationId: 90));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleFitService().googleFitServiceInit();
  await backgroudServiseInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}

