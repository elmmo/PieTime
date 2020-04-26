import 'package:flutter/material.dart';
import 'Util.dart';

class SetTime extends StatefulWidget {
  @override
  _SetTimeState createState() => new _SetTimeState();
}

class _SetTimeState extends State<SetTime> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(color: Colors.blue, width:100, height: 200), 
        Expanded(
          child: Container(
            color: Colors.amber,
            width: 100,
          )
        )
    ]);
  }
}