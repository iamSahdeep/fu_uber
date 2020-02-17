import 'package:flutter/cupertino.dart';
import 'package:fu_uber/Core/Constants/DemoData.dart';
import 'package:fu_uber/Core/Models/UserDetails.dart';
import 'package:fu_uber/Core/Models/UserPlaces.dart';
import 'package:fu_uber/Core/Repository/Repository.dart';

class UserDetailsModel extends ChangeNotifier {
  String uuid;
  String photoUrl;
  String name;
  String email;
  String phone;
  String ongoingRide;
  List<String> previousRides;
  List<UserPlaces> favouritePlaces;

  UserDetailsModel() {
    UserDetails userDetails = DemoData.currentUserDetails;
    uuid = userDetails.uuid;
    photoUrl = userDetails.photoUrl;
    name = userDetails.name;
    email = userDetails.email;
    phone = userDetails.phone;
    ongoingRide = userDetails.ongoingRide;
    previousRides = userDetails.previousRides;
    favouritePlaces = userDetails.favouritePlaces;
  }

  setStaticData(UserDetails userDetails) {}

  changeName(String newName) {}

  addToFavouritePlace(UserPlaces userPlaces) {
    if (favouritePlaces.length >= 5) {
      favouritePlaces.insert(0, userPlaces);
      favouritePlaces.removeLast();
    } else {
      favouritePlaces.add(userPlaces);
    }
    Repository.addFavPlacesToDataBase(favouritePlaces);
    notifyListeners();
  }
}
