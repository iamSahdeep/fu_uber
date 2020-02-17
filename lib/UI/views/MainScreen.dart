import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fu_uber/Core/Constants/colorConstants.dart';
import 'package:fu_uber/Core/ProviderModels/MapModel.dart';
import 'package:fu_uber/Core/ProviderModels/UINotifiersModel.dart';
import 'package:fu_uber/Core/ProviderModels/UserDetailsModel.dart';
import 'package:fu_uber/Core/Utils/BasicShapeUtils.dart';
import 'package:fu_uber/UI/shared/NoInternetWidget.dart';
import 'package:fu_uber/UI/shared/PredictionsLIstAutoComplete.dart';
import 'package:fu_uber/UI/views/ProfileScreen.dart';
import 'package:fu_uber/UI/widgets/BottomSheetMenuMap.dart';
import 'package:fu_uber/UI/widgets/SearchingRideBox.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

/// MainScreen  :  It contains the code of the MAP SCREEN, the Screen just after the Location Permissions.
class MainScreen extends StatefulWidget {
  // Material Page Route
  static const route = "/mainScreen";

  // Tag for logging
  static const TAG = "MainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  AnimationController loadingController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    loadingController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation = Tween<double>(begin: 0, end: 40).animate(new CurvedAnimation(
        parent: loadingController, curve: Curves.easeInOutCirc));
    loadingController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        loadingController.reverse(from: 1);
      }
    });
    loadingController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    loadingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapModel = Provider.of<MapModel>(context);
    final userDetailsModel = Provider.of<UserDetailsModel>(context);
    final uiNotifiersModel = Provider.of<UINotifiersModel>(context);

    return Material(
      child: Scaffold(
          resizeToAvoidBottomPadding: true,
          body: Stack(
            children: <Widget>[
              SlidingUpPanel(
                onPanelSlide: uiNotifiersModel.setOriginDestinationVisibility,
                onPanelOpened: () {
                  uiNotifiersModel.onPanelOpen();
                  mapModel.panelIsOpened();
                },
                onPanelClosed: () {
                  uiNotifiersModel.onPanelClosed();
                  mapModel.panelIsClosed();
                },
                maxHeight: MediaQuery
                    .of(context)
                    .size
                    .height / 1.3,
                parallaxEnabled: true,
                parallaxOffset: 0.5,
                color: Colors.transparent,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    blurRadius: 8.0,
                    color: Color.fromRGBO(0, 0, 0, 0),
                  )
                ],
                controller: uiNotifiersModel.panelController,
                borderRadius: ShapeUtils.borderRadiusGeometry,
                body: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: mapModel.currentPosition,
                      zoom: mapModel.currentZoom),
                  onMapCreated: mapModel.onMapCreated,
                  mapType: MapType.normal,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  zoomGesturesEnabled: true,
                  markers: mapModel.markers,
                  onCameraMove: mapModel.onCameraMove,
                  polylines: mapModel.polyLines,
                ),
                collapsed: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FloatingActionButton(
                        onPressed: mapModel.onMyLocationFabClicked,
                        backgroundColor: ConstantColors.PrimaryColor,
                        child: Icon(Icons.my_location),
                      ),
                    )
                  ],
                ),
                panel: BottomSheetMapMenu(),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 20),
                          child: SizedBox(
                            height: 50,
                            child: InkResponse(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ProfileScreen.route,
                                    arguments: "dsad");
                              },
                              child: ClipOval(
                                child: FadeInImage(
                                    placeholder: AssetImage(
                                        "images/destinationIcon.png"),
                                    image: NetworkImage(
                                        userDetailsModel.photoUrl,
                                        scale: 0.5)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible:
                      uiNotifiersModel.originDestinationVisibility < 0.2 ||
                          uiNotifiersModel.searchingRide
                          ? false
                          : true,
                      child: Opacity(
                        opacity: uiNotifiersModel.originDestinationVisibility,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0,
                                      right: 10,
                                      left: 10,
                                      bottom: 10),
                                  child: SizedBox(
                                      width: 30,
                                      child: Image.asset(
                                        "images/originDestinationDistanceIcon.png",
                                        fit: BoxFit.fitWidth,
                                      )),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      PredictionListAutoComplete(
                                        data: mapModel.pickupPredictions,
                                        textField: TextField(
                                          cursorColor: Colors.black,
                                          onSubmitted:
                                          mapModel.onPickupTextFieldChanged,
                                          //onChanged: mapModel.onPickupTextFieldChanged, not using it for now
                                          controller: mapModel
                                              .pickupFormFieldController,
                                          decoration: InputDecoration(
                                            labelText: "Origin",
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                                top: 15, right: 20, bottom: 10),
                                          ),
                                        ),
                                        itemTap: mapModel
                                            .onPickupPredictionItemClick,
                                      ),
                                      PredictionListAutoComplete(
                                        data: mapModel.destinationPredictions,
                                        textField: TextField(
                                          cursorColor: Colors.black,
                                          onSubmitted: mapModel
                                              .onDestinationTextFieldChanged,
                                          //onChanged:mapModel.onDestinationTextFieldChanged,
                                          controller: mapModel
                                              .destinationFormFieldController,
                                          decoration: InputDecoration(
                                            labelText: "Destination",
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                                right: 20, bottom: 15),
                                          ),
                                        ),
                                        itemTap: mapModel
                                            .onDestinationPredictionItemClick,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: uiNotifiersModel.searchingRide,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SearchingRideBox(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: NoInternetWidget(),
              ),
            ],
          )),
    );
  }
}