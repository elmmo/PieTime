import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import '../OrgComponents.dart';

class SetTime extends StatefulWidget {
  final Function callback; 
  final BuildContext originalContext; 
  
  SetTime(this.callback, this.originalContext);

  @override
  _SetTimeState createState() => new _SetTimeState();
}

class _SetTimeState extends State<SetTime> {
  Duration _duration = Duration(hours: 0, minutes: 0);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: OrgComponents.generateAppBar(),
      drawer: OrgComponents.generateSideDrawer(),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DurationPicker(
                duration: _duration,
                onChange: (val) {
                  this.setState(() => _duration = val);
                },
                snapToMins: 1.0,
              ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    // navigate back to main screen 
                    print("Canceled");
                  }
                ),
                RaisedButton(
                  child: Text("Accept"),
                  onPressed: (isValidTime()) ? () {
                    this.widget.callback(_duration, this.widget.originalContext); 
                  } : null, 
                ),
              ]
            )
          ],
        ),
      ),
    );
  }

  // checks if there is any time on the clock 
  bool isValidTime() => _duration.inMinutes > Duration(minutes: 0).inMinutes; 
}
