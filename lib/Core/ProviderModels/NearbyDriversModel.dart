import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:fu_uber/Core/Models/Drivers.dart';
import 'package:fu_uber/Core/Repository/Repository.dart';

class NearbyDriversModel extends ChangeNotifier {
  List<Driver> nearbyDrivers;
  final nearbyDriverStreamController = StreamController<List<Driver>>();

  get nearbyDriverList => nearbyDrivers;

  Stream<List<Driver>> get dataStream => nearbyDriverStreamController.stream;

  NearbyDriversModel() {
    //We will be listening to the nearbyDrivers events like, there location Updates etc.
    //using streams maybe..
    Repository.getNearbyDrivers(nearbyDriverStreamController);

    dataStream.listen((list) {
      nearbyDrivers = list;
      notifyListeners();
    });
  }

  void closeStream() {
    nearbyDriverStreamController.close();
  }
}
