import 'package:flutter/material.dart';
import 'package:fu_uber/Core/Constants/colorConstants.dart';
import 'package:fu_uber/Core/ProviderModels/CurrentRideCreationModel.dart';
import 'package:fu_uber/Core/ProviderModels/UINotifiersModel.dart';
import 'package:provider/provider.dart';

class SearchingRideBox extends StatefulWidget {
  @override
  _SearchingRideBoxState createState() => _SearchingRideBoxState();
}

class _SearchingRideBoxState extends State<SearchingRideBox>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final uiNotifier = Provider.of<UINotifiersModel>(context);
    final currentRideDetailsModel =
    Provider.of<CurrentRideCreationModel>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Searching for a Ride",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    constraints: BoxConstraints(maxHeight: 2.0),
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: ConstantColors.PrimaryColor,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "It may take few minutes, according to the availability",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                          onPressed: () {
                            uiNotifier.searchingRideNotify();
                          },
                          color: ConstantColors.PrimaryColor,
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
