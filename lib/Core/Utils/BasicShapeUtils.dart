import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShapeUtils {
  static BorderRadiusGeometry borderRadiusGeometry = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  static RoundedRectangleBorder selectedCardShape = RoundedRectangleBorder(
      side: new BorderSide(color: Colors.grey, width: 2.0),
      borderRadius: BorderRadius.circular(4.0));
  static RoundedRectangleBorder notSelectedCardShape = RoundedRectangleBorder(
      side: new BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(4.0));

  static RoundedRectangleBorder rounderCard = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0));
}
