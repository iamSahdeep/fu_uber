import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fu_uber/Core/ProviderModels/VerificationModel.dart';
import 'package:fu_uber/UI/shared/ErrorDialogue.dart';
import 'package:fu_uber/UI/views/LocationPermissionScreen.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

class OtpBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final verificationModel = Provider.of<VerificationModel>(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(25),
          child: Text(
            'Enter OTP Here',
            style: TextStyle(fontSize: 30),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25),
          child: PinCodeTextField(
            autofocus: false,
            controller: verificationModel.oTPTextController,
            hideCharacter: true,
            highlight: true,
            highlightColor: Colors.black,
            defaultBorderColor: Colors.black,
            hasTextBorderColor: Colors.green,
            maxLength: 4,
            hasError: verificationModel.ifOtpHasError,
            maskCharacter: "*",
            pinCodeTextFieldLayoutType:
            PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
            wrapAlignment: WrapAlignment.start,
            pinBoxDecoration:
            ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
            pinTextStyle: TextStyle(fontSize: 30.0),
            pinTextAnimatedSwitcherTransition:
            ProvidedPinBoxTextAnimation.scalingTransition,
            pinTextAnimatedSwitcherDuration: Duration(milliseconds: 200),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: RaisedButton(
            disabledColor: Colors.black87,
            color: Colors.black87,
            onPressed: () {
              verificationModel
                  .setOtp(verificationModel.oTPTextController.text);
              verificationModel.updateCircularLoadingOtp(true);
              Future.delayed(Duration(seconds: 5)).then((_) {
                verificationModel.oTPVerification().then((response) {
                  verificationModel.updateCircularLoadingOtp(true);
                  if (response == 1) {
                    Navigator.pushReplacementNamed(
                        context, LocationPermissionScreen.route);
                  } else {
                    verificationModel.updateCircularLoadingOtp(false);
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return ErrorDialogue(
                            errorTitle: "Wrong OTP",
                            errorMessage:
                            "The OTP you entered is wrong please recheck and try again.",
                          );
                        });
                  }
                });
              });
            },
            child: Text(
              'Verify',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: verificationModel.shopCircularLoaderOTP
              ? CircularProgressIndicator()
              : SizedBox(
            width: 0,
            height: 0,
          ),
        )
      ],
    );
  }
}
