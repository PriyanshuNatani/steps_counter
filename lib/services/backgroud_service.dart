
import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:steps_counter/screens/home_controller.dart';
import 'package:workmanager/workmanager.dart';

import 'local_notfication_service.dart';

FlutterLocalNotificationsPlugin flutterLocalPlugin = FlutterLocalNotificationsPlugin();
AndroidNotificationChannel notificationChannel = AndroidNotificationChannel("FIT", "FIT",description: "FIT...",importance: Importance.high);


@pragma("vm:enry-point")
void onStart(ServiceInstance service){
  
   var controller =  Get.put(HomeController());
  DartPluginRegistrant.ensureInitialized();
   service.on("stopService").listen((event) { 
   service.stopSelf();
  });
  
  Timer.periodic(Duration(seconds: 3), (Timer t) => controller.getTrackingData());
}


class BackgroudService {

  backgroudServiseWorkManagerInit(Function callbackDispatcher,String taskName){
    Workmanager().initialize(callbackDispatcher); // Create an instance of Workmanager
    Workmanager().registerPeriodicTask(
    "1",
    taskName, // This is the value that will be returned in the callbackDispatcher
    frequency: Duration(seconds: 900),
    initialDelay: Duration(seconds: 10),
    constraints: Constraints(
      requiresCharging: true,
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true
    ),
  );
  }

  Future<void> backgroudServiseInit()async{
    var service =  FlutterBackgroundService();
    
      await flutterLocalPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);

    await service.configure(iosConfiguration: IosConfiguration(
     // onBackground: iosBackground,
      onForeground: onStart
    ), androidConfiguration: AndroidConfiguration(onStart: onStart,autoStart: false,isForegroundMode: true,notificationChannelId: "FIT",
    initialNotificationTitle: "FIT",initialNotificationContent: "Fit is working on background",foregroundServiceNotificationId: 90));

    service.startService();
  }

  
 
} 