import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fu_uber/Core/Enums/Enums.dart';
import 'package:fu_uber/Core/ProviderModels/RideBookedModel.dart';
import 'package:fu_uber/Core/Utils/BasicShapeUtils.dart';
import 'package:fu_uber/UI/widgets/DriverDetailsWithPin.dart';
import 'package:fu_uber/UI/widgets/DriverReachedWidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OnGoingRideScreen extends StatefulWidget {
  static const route = "/onGoingRideScreen";
  static const TAG = "OnGoingRideScreen";

  @override
  _OnGoingRideScreenState createState() => _OnGoingRideScreenState();
}

class _OnGoingRideScreenState extends State<OnGoingRideScreen> {
  @override
  Widget build(BuildContext context) {
    final rideBookedProvider = Provider.of<RideBookedModel>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: 160,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            isDraggable: false,
            defaultPanelState: PanelState.OPEN,
            color: Colors.transparent,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                blurRadius: 8.0,
                color: Color.fromRGBO(0, 0, 0, 0),
              )
            ],
            borderRadius: ShapeUtils.borderRadiusGeometry,
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: rideBookedProvider.originLatLng, zoom: 16),
              onMapCreated: rideBookedProvider.onMapCreated,
              mapType: MapType.normal,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              zoomGesturesEnabled: true,
              markers: rideBookedProvider.markers,
              onCameraMove: rideBookedProvider.onCameraMove,
              polylines: rideBookedProvider.polyLines,
            ),
            panel: rideBookedProvider.driverStatus == DriverStatus.OnWay
                ? DriverDetailsWithPin()
                : rideBookedProvider.driverStatus == DriverStatus.InRoute
                ? DriverDetailsWithPin()
                : DriverReachedWidget(),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 60.0, horizontal: 25.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  Icons.dehaze,
                  color: Colors.black,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Home",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: kToolbarHeight * 2, left: 20, right: 20),
            child: SizedBox(
              height: kToolbarHeight * 1.5,
              width: double.infinity,
              child: Card(
                color: Colors.black87,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            Icons.directions_car,
                            color: Colors.white,
                          ),
                          Text(
                            rideBookedProvider.timeLeftToReach.toString() +
                                "min",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white30,
                      height: kToolbarHeight * 1.5,
                      width: 3,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Meet at fdsffds fd saf ffds",
                          maxLines: 2,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
