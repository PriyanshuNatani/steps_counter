import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:steps_counter/services/google_fit_service.dart';

class HomeController extends GetxController {
  final _googleFitService = GoogleFitService();
  var googleFitDataType = Rxn<GoogleFitDataType?>();
  
  void getTrackingData() async {
    googleFitDataType.value = await _googleFitService.getData();
  }
}
