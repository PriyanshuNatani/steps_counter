import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:health/health.dart';
import 'package:steps_counter/services/google_fit_service.dart';

class HomeController extends GetxController {
  final _googleFitService = GoogleFitService();
  var googleFitDataType = Rxn<GoogleFitDataType?>();

    var totalCaloriesBurned = 0.0.obs;
  var totalDistanceCovered = 0.0.obs
;  
  void getTrackingData({int? count}) async {
    googleFitDataType.value = await _googleFitService.getData(count:count);
     var calVal = 0.0;
     var disVal = 0.0;

    for(int i = 0; i< (googleFitDataType.value?.healthData?.length??0);i++){
    
    
      if(googleFitDataType.value?.healthData?[i].type.toString().toUpperCase() == "HEALTHDATATYPE.ACTIVE_ENERGY_BURNED"){
        calVal += double.parse(googleFitDataType.value?.healthData?[i].value.toString()??"0.0");
    }
     if(googleFitDataType.value?.healthData?[i].type.toString().toUpperCase() == "HEALTHDATATYPE.DISTANCE_DELTA"){
        disVal += double.parse(googleFitDataType.value?.healthData?[i].value.toString()??"0.0");
    }
   
  }

  totalCaloriesBurned.value = calVal;
  totalDistanceCovered.value = disVal/1000;
}
}