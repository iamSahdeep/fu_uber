import 'package:flutter/cupertino.dart';
import 'package:fu_uber/Core/Enums/Enums.dart';
import 'package:fu_uber/Core/Repository/Repository.dart';

class VerificationModel extends ChangeNotifier {
  String phoneNumber;
  String otp;

  bool ifOtpHasError = true;
  bool showCircularLoader = false;
  bool shopCircularLoaderOTP = false;

  updateCircularLoading(bool b) {
    showCircularLoader = b;
    notifyListeners();
  }

  TextEditingController oTPTextController = TextEditingController();

  setPhoneNumber(String phone) {
    phoneNumber = phone;
    notifyListeners();
  }

  setOtp(String otpp) {
    otp = otpp;
    notifyListeners();
  }

  Future<AuthStatus> isUserAlreadyAuthenticated() async {
    return await Repository.isUserAlreadyAuthenticated();
  }

  Future<int> handlePhoneVerification() async {
    return await Repository.sendOTP(phoneNumber);
  }

  Future<int> oTPVerification() async {
    return await Repository.verifyOtp(otp);
  }

  void updateCircularLoadingOtp(bool param0) {
    shopCircularLoaderOTP = param0;
    notifyListeners();
  }
}
