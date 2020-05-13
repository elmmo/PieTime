import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';  
  
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
