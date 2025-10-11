import 'package:get/get.dart';
import '../model/car_model.dart';

class SavedCarController extends GetxController {
  var savedCars = <CarModel>[].obs;
  bool toggleSave(CarModel car) {
    if (savedCars.contains(car)) {
      savedCars.remove(car);
      return false;
    } else {
      savedCars.add(car);
      return true;
    }
  }

  bool isSaved(CarModel car) => savedCars.contains(car);
}
