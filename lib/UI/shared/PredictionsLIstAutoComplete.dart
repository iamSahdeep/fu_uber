import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fu_uber/UI/widgets/PredictionItemView.dart';
import 'package:google_maps_webservice/places.dart';

/// An list picker like Widget with textField to show
/// AutoComplete just like Google Maps,
/// @Required : TextField
/// @Optional Data and onTap Callback
typedef onListItemTap = void Function(Prediction prediction);

class PredictionListAutoComplete extends StatefulWidget {
  final TextField textField;
  final List<Prediction> data;
  final onListItemTap itemTap;

  PredictionListAutoComplete(
      {Key key, @required this.textField, @required this.data, this.itemTap})
      : super(key: key);

  @override
  _PredictionListAutoCompleteState createState() =>
      _PredictionListAutoCompleteState();
}

class _PredictionListAutoCompleteState
    extends State<PredictionListAutoComplete> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.textField,
        widget.data != null && widget.data.isNotEmpty
            ? Column(
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkResponse(
                      onTap: () => widget.itemTap(widget.data[index]),
                      child: PredictionItemView(
                          prediction: widget.data[index]));
                }),
            ListTile(
              title: Text("Powered By Google"),
            )
          ],
        )
            : SizedBox(
          height: 0,
          width: 0,
        ),
      ],
    );
  }
}
