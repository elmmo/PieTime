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
  DateTime _endTime = new DateTime.now(); 

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: OrgComponents.generateAppBar(context),
      drawer: OrgComponents.generateSideDrawer(),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // the set time picker 
            DurationPicker(
                duration: _duration,
                onChange: (val) {
                  this.setState(() => _duration = val);
                  setEndTime(); 
                },
                snapToMins: 1.0,
              ),
            // the accept and cancel buttons 
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    // navigate back to main screen 
                    Navigator.pop(context); 
                  }
                ),
                RaisedButton(
                  child: Text("Accept"),
                  onPressed: (isValidTime()) ? () {
                    this.widget.callback(_duration, this.widget.originalContext); 
                  } : null, 
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 70, 0, 10),
                  child: Text(getEndTimeString(), style: TextStyle(color: Colors.white, fontSize: 20))
                )
              ]
            ),
          ],
        ),
      ),
    );
  }

  void setEndTime() {
    if (_duration != new Duration(minutes: 0)) {
      _endTime = DateTime.now().add(_duration);
    }
  }

  String getEndTimeString() {
    String timeMarker; 
    String result = "End Time: "; 
    if (_endTime.hour > 12) {
      timeMarker = "PM";
      result += (_endTime.hour-12).toString(); 
    } else { 
      timeMarker = "AM";
      result += _endTime.hour.toString(); 
    }
    result += ":" + _endTime.minute.toString() + timeMarker; 
    return result; 
  }

  // checks if there is any time on the clock 
  bool isValidTime() => _duration.inMinutes > Duration(minutes: 0).inMinutes; 
}
