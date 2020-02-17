import 'package:flutter/material.dart';
import 'package:fu_uber/Core/ProviderModels/CurrentRideCreationModel.dart';
import 'package:fu_uber/Core/ProviderModels/MapModel.dart';
import 'package:fu_uber/Core/ProviderModels/NearbyDriversModel.dart';
import 'package:fu_uber/Core/ProviderModels/PermissionHandlerModel.dart';
import 'package:fu_uber/Core/ProviderModels/RideBookedModel.dart';
import 'package:fu_uber/Core/ProviderModels/UINotifiersModel.dart';
import 'package:fu_uber/Core/ProviderModels/UserDetailsModel.dart';
import 'package:fu_uber/Core/ProviderModels/VerificationModel.dart';
import 'package:fu_uber/UI/views/LocationPermissionScreen.dart';
import 'package:fu_uber/UI/views/MainScreen.dart';
import 'package:fu_uber/UI/views/OnGoingRideScreen.dart';
import 'package:fu_uber/UI/views/ProfileScreen.dart';
import 'package:fu_uber/UI/views/SignIn.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


class MyApp extends StatelessWidget {
  static const String TAG = "MyApp";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PermissionHandlerModel>(
          builder: (context) => PermissionHandlerModel(),
        ),
        ChangeNotifierProvider<MapModel>(
          builder: (context) => MapModel(),
        ),
        ChangeNotifierProxyProvider<MapModel, RideBookedModel>(
            initialBuilder: (_) => RideBookedModel(),
            builder: (_, foo, bar) {
              bar.originLatLng = foo.pickupPosition;
              bar.destinationLatLng = foo.destinationPosition;
              return bar;
            }),
        ChangeNotifierProvider<VerificationModel>(
          builder: (context) => VerificationModel(),
        ),
        ChangeNotifierProvider<NearbyDriversModel>(
          builder: (context) => NearbyDriversModel(),
        ),
        ChangeNotifierProvider<UserDetailsModel>(
          builder: (context) => UserDetailsModel(),
        ),
        ChangeNotifierProvider<CurrentRideCreationModel>(
          builder: (context) => CurrentRideCreationModel(),
        ),
        ChangeNotifierProvider<UINotifiersModel>(
          builder: (context) => UINotifiersModel(),
        )
      ],
      child: MaterialApp(
          title: 'Fu_Uber',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          navigatorKey: navigatorKey,
          initialRoute: '/',
          routes: {
            LocationPermissionScreen.route: (context) =>
                LocationPermissionScreen(),
            MainScreen.route: (context) => MainScreen(),
            SignInPage.route: (context) => SignInPage(),
            ProfileScreen.route: (context) => ProfileScreen(),
            OnGoingRideScreen.route: (context) => OnGoingRideScreen()
          },
          home: Scaffold(body: LocationPermissionScreen())),
    );
  }
}
