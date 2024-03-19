import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:steps_counter/screens/home_controller.dart';
import 'package:steps_counter/services/google_fit_service.dart';
import 'package:steps_counter/services/local_notfication_service.dart';
import 'package:workmanager/workmanager.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int totalCount = 0;
  double totalCaloriesBurned = 0;
  double totalDistanceCovered = 0;
  List<HealthDataPoint> healthData = [];

  final _localNotificationService = LocalNotificationService();

 var controller = Get.put(HomeController());
  @override
  void initState() {
    super.initState();
    _localNotificationService.initializeNotifications();
    controller.getTrackingData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fit Life')),
      body: Obx(
       ()=> SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.blue,
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Steps',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${controller.googleFitDataType.value?.stepsCount??""}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                ListTile(
                  leading: Icon(Icons.local_fire_department, color: Colors.orange),
                  title: Text('Total Calories Burned: $totalCaloriesBurned '),
                ),
                ListTile(
                  leading: Icon(Icons.directions_walk, color: Colors.green),
                  title:
                      Text('Total Distance Covered: $totalDistanceCovered meters'),
                ),
                ElevatedButton(onPressed: (){
                   FlutterBackgroundService().startService();
                }, child: Text("Start service")),
                SizedBox(height: 10.0),
                     ElevatedButton(onPressed: (){
                   FlutterBackgroundService().invoke('stopService');
                }, child: Text("Stop service")),
                    SizedBox(height: 20.0),
                Text('Health Data:'),
                SizedBox(height: 10.0),
                Text((controller.googleFitDataType.value?.healthData??"").toString()),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
        controller.getTrackingData();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
