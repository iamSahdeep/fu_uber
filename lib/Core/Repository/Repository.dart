import 'dart:async';

import 'package:fu_uber/Core/Enums/Enums.dart';
import 'package:fu_uber/Core/Models/Drivers.dart';
import 'package:fu_uber/Core/Models/UserPlaces.dart';
import 'package:fu_uber/Core/Networking/ApiProvider.dart';

class Repository {
  static Future<AuthStatus> isUserAlreadyAuthenticated() async {
    return AuthStatus.Authenticated;
  }

  static Future<int> sendOTP(String phone) async {
    return await ApiProvider.sendOtpToUser(phone);
  }

  static Future<int> verifyOtp(String text) async {
    //just returning 1
    //somehow check the otp
    return await ApiProvider.verifyOtp(text);
  }

  static void getNearbyDrivers(
      StreamController<List<Driver>> nearbyDriverStreamController) {
    nearbyDriverStreamController.sink.add(ApiProvider.getNearbyDrivers());
  }

  static void addFavPlacesToDataBase(List<UserPlaces> data) {
    //
  }
}
