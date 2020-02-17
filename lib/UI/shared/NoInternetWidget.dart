import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoInternetWidget extends StatefulWidget {
  @override
  _NoInternetWidgetState createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> {
  bool isConnected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          return snapshot.data == ConnectivityResult.none
              ? Container(
                  width: double.infinity,
                  color: Colors.redAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      " Cannot connect to Aeober servers",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : SizedBox();
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
