import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fu_uber/Core/ProviderModels/VerificationModel.dart';
import 'package:fu_uber/Core/Utils/LogUtils.dart';
import 'package:fu_uber/UI/widgets/OtpBottomSheet.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();

class SignInPage extends StatefulWidget {
  // Material Page Route
  static const route = "/signinscreen";

  // Tag for logging
  static const TAG = "SignInScreen";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final phoneTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final verificationModel = Provider.of<VerificationModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Text(
                'Enter Your Phone Number to get Started...',
                style: TextStyle(fontSize: 35),
              ),
            ),
            Card(
              child: Container(
                height: kToolbarHeight,
                width: width / 1.2,
                margin: EdgeInsets.only(right: 0, top: 3, bottom: 3, left: 10),
                child: Form(
                  key: _phoneFormKey,
                  child: TextFormField(
                    controller: phoneTextController,
                    cursorWidth: 2,
                    onFieldSubmitted: verificationModel.setPhoneNumber,
                    validator: (value) {
                      if (value.length < 10 || value.length > 13) {
                        return "Enter a Valid Phone Number";
                      } else
                        return null;
                    },
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontFamily: 'Righteous',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w200,
                      wordSpacing: 2,
                      fontSize: kToolbarHeight / 2.3,
                      letterSpacing: 2,
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        hintText: "Phone number", border: InputBorder.none),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: verificationModel.showCircularLoader
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: 0,
                      height: 0,
                    ),
            ),
            InkResponse(
              onTap: () {
                if (_phoneFormKey.currentState.validate())
                  verificationModel.updateCircularLoading(true);
                Future.delayed(Duration(seconds: 5)).then((_) {
                  verificationModel.handlePhoneVerification().then((response) {
                    ProjectLog.logIt(
                        SignInPage.TAG, "PhoneVerification Response", response);
                    verificationModel.updateCircularLoading(false);
                    if (response == 1) {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        context: context,
                        builder: (context) => OtpBottomSheet(),
                      );
                    } else {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Something Went Wrong.. Retry!")));
                    }
                  });
                });
              },
              child: Column(
                children: <Widget>[
                  Text('Lets Go...'),
                  Icon(Icons.arrow_forward)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
