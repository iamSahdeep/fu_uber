import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fu_uber/Core/Constants/colorConstants.dart';

typedef OnPressed = void Function();

class CircularFlatButton extends StatelessWidget {
  final double size;
  final Widget child;
  final String name;
  final OnPressed onPressed;

  const CircularFlatButton(
      {Key key, this.size, this.name, this.onPressed, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size,
        width: size,
        child: FlatButton(
            shape: CircleBorder(),
            disabledColor: ConstantColors.DeepBlue.withOpacity(0.2),
            onPressed: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                child,
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurpleAccent,
                  ),
                )
              ],
            )));
  }
}
