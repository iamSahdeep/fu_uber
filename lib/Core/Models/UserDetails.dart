import 'package:fu_uber/Core/Models/UserPlaces.dart';

class UserDetails {
  String uuid;
  String photoUrl;
  String name;
  String email;
  String phone;
  String ongoingRide;
  List<String> previousRides;
  List<UserPlaces> favouritePlaces;

  UserDetails(this.uuid, this.photoUrl, this.name, this.email, this.phone,
      this.ongoingRide,
      this.previousRides, this.favouritePlaces);
}
