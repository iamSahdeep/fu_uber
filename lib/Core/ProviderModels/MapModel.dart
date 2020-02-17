import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fu_uber/Core/Constants/Constants.dart';
import 'package:fu_uber/Core/Constants/DemoData.dart';
import 'package:fu_uber/Core/Constants/colorConstants.dart';
import 'package:fu_uber/Core/Models/Drivers.dart';
import 'package:fu_uber/Core/Repository/mapRepository.dart';
import 'package:fu_uber/Core/Utils/LogUtils.dart';
import 'package:fu_uber/Core/Utils/Utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as location;

/// A viewModel kind of class for handling Map related information and updating.
/// We are using Provider with notifyListeners() for the sake of simplicity but will update with dynamic approach
/// Provider : https://pub.dev/packages/provider

class MapModel extends ChangeNotifier {
  final mapScreenScaffoldKey = GlobalKey<ScaffoldState>();

  // Tag for Logs
  static const TAG = "MapModel";

  //Current Position and Destination Position and Pickup Point
  LatLng _currentPosition, _destinationPosition, _pickupPosition;

  // Default Camera Zoom
  double currentZoom = 19;

  // Set of all the markers on the map
  final Set<Marker> _markers = Set();

  // Set of all the polyLines/routes on the map
  final Set<Polyline> _polyLines = Set();

  // Pickup Predictions using Places Api, It is the list of Predictions we get from the textchanges the PickupText field in the mainScreen
  List<Prediction> pickupPredictions = [];

  //Same as PickupPredictions but for destination TextField in mainScreen
  List<Prediction> destinationPredictions = [];

  //Map Controller
  GoogleMapController _mapController;

  // Map Repository for connection to APIs
  MapRepository _mapRepository = MapRepository();

  // FormField Controller for the pickup field
  TextEditingController pickupFormFieldController = TextEditingController();

  // FormField Controller for the destination field
  TextEditingController destinationFormFieldController =
  TextEditingController();

  // Location Object to get current Location
  location.Location _location = location.Location();

  // currentPosition Getter
  LatLng get currentPosition => _currentPosition;

  // currentPosition Getter
  LatLng get destinationPosition => _destinationPosition;

  // currentPosition Getter
  LatLng get pickupPosition => _pickupPosition;

  // MapRepository Getter
  MapRepository get mapRepo => _mapRepository;

  // MapController Getter
  GoogleMapController get mapController => _mapController;

  // Markers Getter
  Set<Marker> get markers => _markers;

  // PolyLines Getter
  Set<Polyline> get polyLines => _polyLines;

  get randomZoom => 13.0 + Random().nextInt(4);

  /// Default Constructor
  MapModel() {
    ProjectLog.logIt(TAG, "MapModel Constructor", "...");

    //getting user Current Location
    _getUserLocation();

    fetchNearbyDrivers(DemoData.nearbyDrivers);

    //A listener on _location to always get current location and update it.
    _location.onLocationChanged().listen((event) async {
      _currentPosition = LatLng(event.latitude, event.longitude);
      markers.removeWhere((marker) {
        return marker.markerId.value == Constants.currentLocationMarkerId;
      });
      markers.remove(
          Marker(markerId: MarkerId(Constants.currentLocationMarkerId)));
      markers.add(Marker(
          markerId: MarkerId(Constants.currentLocationMarkerId),
          position: _currentPosition,
          rotation: event.heading - 78,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(
            await Utils.getBytesFromAsset("images/currentUserIcon.png", 280),
          )));
      notifyListeners();
    });
  }

  ///Callback whenever data in Pickup TextField is changed
  ///onChanged()
  onPickupTextFieldChanged(String string) async {
    ProjectLog.logIt(TAG, "onPickupTextFieldChanged", string);
    if (string.isEmpty) {
      pickupPredictions = null;
    } else {
      try {
        await mapRepo.getAutoCompleteResponse(string).then((response) {
          updatePickupPointSuggestions(response.predictions);
          ProjectLog.logIt(
              TAG, "UpdatePickupPredictions", response.predictions.toString());
        });
      } catch (e) {
        print(e);
      }
    }
  }

  ///Callback whenever data in destination TextField is changed
  ///onChanged()
  onDestinationTextFieldChanged(String string) async {
    ProjectLog.logIt(TAG, "onDestinationTextFieldChanged", string);
    if (string.isEmpty) {
      destinationPredictions = null;
    } else {
      try {
        await mapRepo.getAutoCompleteResponse(string).then((response) {
          updateDestinationSuggestions(response.predictions);
          ProjectLog.logIt(TAG, "UpdateDestinationPredictions",
              response.predictions.toString());
        });
      } catch (e) {
        print(e);
      }
    }
  }

  ///Getting current Location : Works only one time
  void _getUserLocation() async {
    ProjectLog.logIt(TAG, "getUserCurrentLocation", "...");

    _location.getLocation().then((data) async {
      _currentPosition = LatLng(data.latitude, data.longitude);

      _pickupPosition = _currentPosition;

      ProjectLog.logIt(
          TAG, "Initial Position is ", _currentPosition.toString());

      pickupFormFieldController.text = await mapRepo
          .getPlaceNameFromLatLng(LatLng(data.latitude, data.longitude));
      updatePickupMarker();
      notifyListeners();
    });
  }

  ///Creating a Route
  void createCurrentRoute(String encodedPoly) {
    ProjectLog.logIt(TAG, "createCurrentRoute", encodedPoly);
    _polyLines.add(Polyline(
        polylineId: PolylineId(Constants.currentRoutePolylineId),
        width: 3,
        geodesic: true,
        points: Utils.convertToLatLng(Utils.decodePoly(encodedPoly)),
        color: ConstantColors.PrimaryColor));
    notifyListeners();
  }

  ///Adding or updating Destination Marker on the Map
  updateDestinationMarker() async {
    if (destinationPosition == null) return;

    ProjectLog.logIt(
        TAG, "updateDestinationMarker", destinationPosition.toString());
    markers.add(Marker(
        markerId: MarkerId(Constants.destinationMarkerId),
        position: destinationPosition,
        draggable: true,
        onDragEnd: onDestinationMarkerDragged,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(
            await Utils.getBytesFromAsset("images/destinationIcon.png", 80))));
    notifyListeners();
  }

  ///Adding or updating Destination Marker on the Map
  updatePickupMarker() async {
    if (pickupPosition == null) return;
    ProjectLog.logIt(TAG, "updatePickupMarker", pickupPosition.toString());
    _markers.add(Marker(
        markerId: MarkerId(Constants.pickupMarkerId),
        position: pickupPosition,
        draggable: true,
        onDragEnd: onPickupMarkerDragged,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(
            await Utils.getBytesFromAsset("images/pickupIcon.png", 80))));
    notifyListeners();
  }

  ///Updating Pickup Suggestions
  updatePickupPointSuggestions(List<Prediction> predictions) {
    ProjectLog.logIt(
        TAG, "updatePickupPointSuggestions", predictions.toString());
    pickupPredictions = predictions;
    notifyListeners();
  }

  ///Updating Destination
  updateDestinationSuggestions(List<Prediction> predictions) {
    ProjectLog.logIt(
        TAG, "updateDestinationSuggestions", predictions.toString());
    destinationPredictions = predictions;
    notifyListeners();
  }

  ///on Destination predictions item clicked
  onDestinationPredictionItemClick(Prediction prediction) async {
    updateDestinationSuggestions(null);
    ProjectLog.logIt(
        TAG, "onDestinationPredictionItemClick", prediction.description);
    destinationFormFieldController.text = prediction.description;
    _destinationPosition =
    await mapRepo.getLatLngFromAddress(prediction.description);
    onDestinationPositionChanged();
    notifyListeners();
  }

  ///on Pickup predictions item clicked
  onPickupPredictionItemClick(Prediction prediction) async {
    updatePickupPointSuggestions(null);
    ProjectLog.logIt(
        TAG, "onPickupPredictionItemClick", prediction.description);
    pickupFormFieldController.text = prediction.description;

    _pickupPosition =
    await mapRepo.getLatLngFromAddress(prediction.description);
    onPickupPositionChanged();
    notifyListeners();
  }

  // ! SEND REQUEST
  void sendRouteRequest() async {
    ProjectLog.logIt(TAG, "sendRouteRequest", "...");
    if (_pickupPosition == null) {
      pickupFormFieldController.text = "This is required";
      return;
    } else if (_destinationPosition == null) {
      destinationFormFieldController.text = "This is required";
      return;
    }
    await mapRepo
        .getRouteCoordinates(_pickupPosition, _destinationPosition)
        .then((route) {
      createCurrentRoute(route);
      notifyListeners();
    });
  }

  /// listening to camera moving event
  void onCameraMove(CameraPosition position) {
    //ProjectLog.logIt(TAG, "onCameraMove", position.target.toString());
    currentZoom = position.zoom;
    notifyListeners();
  }

  /// when map is created
  void onMapCreated(GoogleMapController controller) {
    ProjectLog.logIt(TAG, "onMapCreated", "null");
    _mapController = controller;
    rootBundle.loadString('assets/mapStyle.txt').then((string) {
      _mapController.setMapStyle(string);
    });
    notifyListeners();
  }

  bool checkDestinationOriginForNull() {
    if (pickupPosition == null || destinationPosition == null)
      return false;
    else
      return true;
  }

  void randomMapZoom() {
    mapController
        .animateCamera(CameraUpdate.zoomTo(15.0 + Random().nextInt(5)));
  }

  void onMyLocationFabClicked() {
    // check if ride is ongoing or not, if not that show current position
    // else we will show the camera at the mid point of both locations
    ProjectLog.logIt(TAG, "Moving to Current Position", "...");
    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        currentPosition, 15.0 + Random().nextInt(4)));
    //its overriding the above statement of zoom. beware
    //randomMapZoom();
  }

  void fetchNearbyDrivers(List<Driver> list) {
    if (list != null && list.isNotEmpty)
      list.forEach((driver) async {
        markers.add(Marker(
            markerId: MarkerId(driver.driverId),
            infoWindow: InfoWindow(title: driver.carDetail.carCompanyName),
            position: driver.currentLocation,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.fromBytes(
                await Utils.getBytesFromAsset("images/carIcon.png", 80))));
        notifyListeners();
      });
  }

  void onDestinationPositionChanged() {
    updateDestinationMarker();
    mapController.animateCamera(
        CameraUpdate.newLatLngZoom(destinationPosition, randomZoom));
    if (pickupPosition != null) sendRouteRequest();
    notifyListeners();
  }

  void onPickupPositionChanged() {
    updatePickupMarker();
    mapController
        .animateCamera(CameraUpdate.newLatLngZoom(pickupPosition, randomZoom));
    if (destinationPosition != null) sendRouteRequest();
    notifyListeners();
  }

  void onPickupMarkerDragged(LatLng value) async {
    _pickupPosition = value;
    pickupFormFieldController.text =
    await mapRepo.getPlaceNameFromLatLng(value);
    onPickupPositionChanged();
    notifyListeners();
  }

  void onDestinationMarkerDragged(LatLng latLng) async {
    _destinationPosition = latLng;
    destinationFormFieldController.text =
    await mapRepo.getPlaceNameFromLatLng(latLng);
    onDestinationPositionChanged();
    notifyListeners();
  }

  void panelIsOpened() {
    if (checkDestinationOriginForNull()) {
      animateCameraForOD();
    } else {
      //Following statement is creating unnecessary zooms. maybe because panelIsOpened is called on every gesture.
      //randomMapZoom();
    }
  }

  void animateCameraForOD() {
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
              northeast: pickupPosition, southwest: destinationPosition),
          100),
    );
  }

  void panelIsClosed() {
    onMyLocationFabClicked();
  }
}
