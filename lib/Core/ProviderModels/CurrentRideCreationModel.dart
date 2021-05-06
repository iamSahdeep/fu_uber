import 'package:flutter/material.dart';
import 'package:fu_uber/Core/Enums/Enums.dart';

class CurrentRideCreationModel extends ChangeNotifier {
  RideType? selectedRideType;
  bool riderFound = false;

  CurrentRideCreationModel() {
    selectedRideType = RideType.Classic;
  }

  String getEstimationFromOriginDestination() {
    return "200";
  }

  carTypeChanged(int index, _) {
    selectedRideType = RideType.values[index];
    notifyListeners();
  }

  searchForRides() {
    Future.delayed(Duration(seconds: 5), () {
      riderFound = true;
      notifyListeners();
    });
  }
}
