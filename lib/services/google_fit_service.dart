import 'package:health/health.dart';
import 'package:steps_counter/services/local_notfication_service.dart';

class GoogleFitService {
  List<HealthDataPoint> healthData = [];
  
  final _localNotificationService =
      LocalNotificationService();

  Future<GoogleFitDataType> getData() async {

  //   await _localNotificationService.showNotification("100");
    HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
   
    var types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.DISTANCE_DELTA,
    ];

    bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();

    healthData = await health.getHealthDataFromTypes(
      now.subtract(Duration(days: 1)),
      now,
      types,
    );

    var midnight = DateTime(now.year, now.month, now.day);
    int? steps = await health.getTotalStepsInInterval(midnight, now);
    var totalCount = steps ?? 0;
    int notificationCounter = 0;


       if (totalCount >= 100 && totalCount < 200 && notificationCounter == 0) {
        await _localNotificationService.showNotification("100");
        notificationCounter ++;
    } else if (totalCount >= 200 && totalCount < 300 && notificationCounter == 1) {
        await _localNotificationService.showNotification("200");
        notificationCounter++;
    } else if (totalCount >= 300 && totalCount < 400 && notificationCounter == 2) {
        await _localNotificationService.showNotification("300");
        notificationCounter++;
    } else if (totalCount >= 400 && totalCount < 500 && notificationCounter == 3) {
        await _localNotificationService.showNotification("400");
        notificationCounter++;
    } else if (totalCount >= 500 && notificationCounter == 4) {
        await _localNotificationService.showNotification("500");
         notificationCounter++;
        // No need for further checks, as we've shown all 5 notifications
        // You can add more logic here if needed
    }
    return GoogleFitDataType(healthData,totalCount);
  }
   
   

}

class GoogleFitDataType {
  List<HealthDataPoint>? healthData;
  int? stepsCount;
  GoogleFitDataType(this.healthData,this.stepsCount);
}
