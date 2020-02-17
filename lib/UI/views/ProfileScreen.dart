import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fu_uber/Core/Constants/DemoData.dart';
import 'package:fu_uber/Core/Models/UserDetails.dart';
import 'package:fu_uber/UI/shared/CircularFlatButton.dart';

class ProfileScreen extends StatefulWidget {
  // Material Page Route
  static const route = "/profilescreen";

  // Tag for logging
  static const TAG = "ProfileScreen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserDetails currentUser = DemoData.currentUserDetails;
    Size size = MediaQuery
        .of(context)
        .size;
    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.height / 1.7,
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(250),
                          bottomRight: Radius.circular(10)),
                      child: SizedBox(
                          height: size.height / 2,
                          width: double.infinity,
                          child: Image.network(
                            currentUser.photoUrl,
                            fit: BoxFit.fitWidth,
                          )),
                    ),
                    Align(
                      alignment: Alignment(0, 1),
                      child: Card(
                        child: SizedBox(
                          width: size.width / 1.3,
                          height: 120,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Text(
                                      "edit",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: Colors.blue,
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                currentUser.name,
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                currentUser.phone,
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                currentUser.email,
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                " ",
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: CircularFlatButton(
                      size: 100,
                      onPressed: null,
                      child: Icon(
                        Icons.directions_car,
                        color: Colors.deepPurpleAccent,
                        size: 50,
                      ),
                      name: "Rides",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: CircularFlatButton(
                      size: 120,
                      onPressed: null,
                      child: Icon(
                        Icons.settings,
                        color: Colors.deepPurpleAccent,
                        size: 70,
                      ),
                      name: "Settings",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: CircularFlatButton(
                      size: 100,
                      onPressed: null,
                      child: Icon(
                        Icons.help,
                        color: Colors.deepPurpleAccent,
                        size: 50,
                      ),
                      name: "Help",
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
