import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driver {
  String driverName;
  String driverImage;
  double driverRating;
  String driverId;
  CarDetail carDetail;
  LatLng
  currentLocation; //location should be of Location Type, for more data, not LatLng

  Driver(this.driverName, this.driverImage, this.driverRating, this.driverId,
      this.carDetail,
      this.currentLocation);
}

class CarDetail {
  String carId;
  String carCompanyName;
  String carModel;
  String carNumber;

  CarDetail(this.carId, this.carCompanyName, this.carModel, this.carNumber);
}
