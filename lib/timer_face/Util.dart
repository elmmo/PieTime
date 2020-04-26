import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';  
import 'PieTimer.dart';
  
// a general dialog system
// context is the build context (depends on where you're placing the alert)
// titleText is the text that will show on top of the alert 
// bodyText is the text within the alert 
void getDialog(context, titleText, bodyText) {
  showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return AlertDialog(
            title: new Text(titleText),
            content: new Text(bodyText),
            backgroundColor: Colors.grey[50],
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Ok"),
                  color: Colors.cyan[800],
                  onPressed: () {
                    Navigator.of(builderContext).pop();
                  })
            ]);
      });
}

Widget drawDottedBorder(List<Widget> widgetsInBorder) {
  return DottedBorder(
    color: Colors.white,
    radius: Radius.circular(12),
    dashPattern: [2.1, 20],
    strokeWidth: 8,
    borderType: BorderType.Circle,
    padding: EdgeInsets.all(6),
      // Red timer circle
      child: Stack(
        children: widgetsInBorder
      )
  );
}
