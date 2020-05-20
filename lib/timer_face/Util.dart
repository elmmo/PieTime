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
            title: new Text(titleText, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
            content: Container(width: double.maxFinite, child: new Text(bodyText, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color))),
            backgroundColor: Theme.of(context).backgroundColor,
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Ok", ),
                  color: Theme.of(context).primaryColorLight,
                  onPressed: () {
                    Navigator.of(builderContext).pop();
                  })
            ]);
      });
}
