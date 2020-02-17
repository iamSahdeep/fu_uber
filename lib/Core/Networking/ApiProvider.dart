import 'package:fu_uber/Core/Constants/DemoData.dart';
import 'package:fu_uber/Core/Models/Drivers.dart';

class ApiProvider {
  static Future<int> sendOtpToUser(String phone) async {
    // WE Will be using APIs to send verification OTP.
    // 1 : OTP SENT Successfully
    // 0 : Something is wrong, network failure etc...
    return 1;
  }

  static Future<int> verifyOtp(String otp) async {
    // WE Will be using APIs to send verification OTP.
    // 1 : OTP SENT Successfully
    // 0 : Something is wrong, network failure etc...
    print(otp);
    if (otp == "1234") {
      return 1;
    } else
      return 0;
  }

  static List<Driver> getNearbyDrivers() {
    //somehow get the list of nearby drivers
    return DemoData.nearbyDrivers;
  }
}
