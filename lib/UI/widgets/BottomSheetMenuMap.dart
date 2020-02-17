import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fu_uber/Core/Constants/DemoData.dart';
import 'package:fu_uber/Core/Constants/colorConstants.dart';
import 'package:fu_uber/Core/ProviderModels/CurrentRideCreationModel.dart';
import 'package:fu_uber/Core/ProviderModels/MapModel.dart';
import 'package:fu_uber/Core/ProviderModels/UINotifiersModel.dart';
import 'package:fu_uber/Core/Utils/BasicShapeUtils.dart';
import 'package:fu_uber/UI/shared/CardSelectionCard.dart';
import 'package:fu_uber/UI/views/OnGoingRideScreen.dart';
import 'package:fu_uber/main.dart';
import 'package:provider/provider.dart';

class BottomSheetMapMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentRideCreationModel =
    Provider.of<CurrentRideCreationModel>(context);
    final uiNotifiersModel = Provider.of<UINotifiersModel>(context);
    final mapModel = Provider.of<MapModel>(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: ShapeUtils.borderRadiusGeometry,
      ),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            height: 100,
            child: Center(
              child: SizedBox(
                width: 100,
                height: 15,
                child: Card(
                  elevation: 5,
                  shape: ShapeUtils.rounderCard,
                  color: ConstantColors.PrimaryColor,
                ),
              ),
            ),
          ),
          Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Choose the type of Ride : ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    CarouselSlider(
                      enableInfiniteScroll: false,
                      initialPage: 1,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: currentRideCreationModel.carTypeChanged,
                      items: DemoData.typesOfCar.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return CarSelectionCard(carTypeMenu: i);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Estimate of Ride : ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        color: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            mapModel.checkDestinationOriginForNull()
                                ? "Etimated amount : ${currentRideCreationModel
                                .getEstimationFromOriginDestination()} Rupees"
                                : "Pin the Destination and Origin",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                InkResponse(
                  onTap: () {
                    uiNotifiersModel.searchingRideNotify();
                    Future.delayed(Duration(seconds: 5), () {
                      uiNotifiersModel.searchingRideNotify();
                      navigatorKey.currentState
                          .pushReplacementNamed(OnGoingRideScreen.route);
                    });
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: ConstantColors.PrimaryColor,
                    child: Center(
                        child: Text(
                          "Book ${currentRideCreationModel.selectedRideType}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
