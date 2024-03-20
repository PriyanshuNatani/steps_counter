import 'package:health/health.dart';
import 'package:steps_counter/services/local_notfication_service.dart';

class GoogleFitService {
  List<HealthDataPoint> healthData = [];

  final _localNotificationService = LocalNotificationService();
  int notificationCounter = -1;
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  bool requested = false;
  var types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA,
  ];

  // Private constructor
  GoogleFitService._privateConstructor();

  // Singleton instance
  static final GoogleFitService _instance =
      GoogleFitService._privateConstructor();

  // Factory method to provide the instance
  factory GoogleFitService() {
    return _instance;
  }

  Future googleFitServiceInit() async {
    if (!requested) {
      requested = await health.requestAuthorization(types);
    }
  }

  Future<GoogleFitDataType> getData({int? count, bool? isBackground}) async {
    if(isBackground??false){
     //  await _localNotificationService.showNotification("100");
    }
    
    var now = DateTime.now();

    healthData = await health.getHealthDataFromTypes(
      now.subtract(Duration(days: 1)),
      now,
      types,
    );

    var midnight = DateTime(now.year, now.month, now.day);
    int? steps = await health.getTotalStepsInInterval(midnight, now);
    var totalCount = 0;
    if (count == null) {
      totalCount = steps ?? 0;
    } else {
      totalCount = count;
    }

 
    if (totalCount >= 100 && totalCount < 200 && notificationCounter == 0) {
      await _localNotificationService.showNotification("100");
      notificationCounter++;
    } else if (totalCount >= 200 &&
        totalCount < 300 &&
        notificationCounter == 1) {
      await _localNotificationService.showNotification("200");
      notificationCounter++;
    } else if (totalCount >= 300 &&
        totalCount < 400 &&
        notificationCounter == 2) {
      await _localNotificationService.showNotification("300");
      notificationCounter++;
    } else if (totalCount >= 400 &&
        totalCount < 500 &&
        notificationCounter == 3) {
      await _localNotificationService.showNotification("400");
      notificationCounter++;
    } else if (totalCount >= 500 && notificationCounter == 4) {
      await _localNotificationService.showNotification("500");
      notificationCounter++;
      
    } else {
      if (totalCount < 100) {
        notificationCounter = 0;
      } else if (totalCount >= 100 && totalCount < 200) {
        notificationCounter = 1;
      } else if (totalCount >= 200 && totalCount < 300) {
        notificationCounter = 2;
      } else if (totalCount >= 300 && totalCount < 400) {
        notificationCounter = 3;
      } else if (totalCount >= 400 && totalCount < 500) {
        notificationCounter = 4;
      } else if (totalCount >= 500) {
        notificationCounter = 5;
      
      }
    }
    return GoogleFitDataType(healthData, totalCount);
  }
}

class GoogleFitDataType {
  List<HealthDataPoint>? healthData;
  int? stepsCount;
  GoogleFitDataType(this.healthData, this.stepsCount);
}
