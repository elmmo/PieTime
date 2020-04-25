import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';  
  
// show alert
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

// draw circle to mimic the look of the timer without timer functionality 
void drawCircle(context, titleText, bodyText) {
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

