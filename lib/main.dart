import 'package:flutter/material.dart';

void main() => runApp(new PieTimerApp());

// entry for the rest of the app 
class PieTimerApp extends StatelessWidget {

  // builds the main container widget 
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Our Title",
      theme: ThemeData(
        primaryColor: Colors.amber,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Baloo 2',
          fontSizeDelta: 30
        )
      ), 
      //home: // call function that loads homepage,
    );
  }
}