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
       appBar: AppBar( // Changes plus icon to close and goes back to home
        title: Text(
          'PieTime',
        ),
        backgroundColor: Colors.grey[900],
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              // Plus icon on the Appbar to the right
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
        ],
      ),
      drawer: OrgComponents.generateSideDrawer(),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
             Padding(
                  padding: EdgeInsets.fromLTRB(0, 70, 0, 30),
                  child: getEndTimeString(),
                ),
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
              buttonMinWidth: 100,
              buttonPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              children: <Widget>[
                FlatButton(
                  child: Text("Cancel", style: TextStyle(fontSize: 20),),
                  onPressed: () {
                    // navigate back to main screen 
                    Navigator.pop(context); 
                  }
                ),
                RaisedButton(
                   child: Text("Accept", style: TextStyle(fontSize: 20),),
                  onPressed: (isValidTime()) ? () {
                    this.widget.callback(_duration, this.widget.originalContext); 
                  } : null, 
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void setEndTime() {
    if (_duration != Duration.zero) {
      _endTime = DateTime.now().add(_duration);
    }
  }

  RichText getEndTimeString() {
    String timeMarker;
    String result = "";
    // String result = "Ends at: ";
    if (_endTime.hour > 12) {
      timeMarker = "PM";
      result += (_endTime.hour - 12).toString();
    } else {
      timeMarker = "AM";
      result += _endTime.hour.toString();
    }
    result += ":" + _endTime.minute.toString().padLeft(2, '0') + timeMarker;
    // Makes "Ends at: " normal weight and the end time bolded
    var text = new RichText(
      text: new TextSpan(
          style: new TextStyle(
            fontSize: 24.0,
          ),
          children: <TextSpan>[
            new TextSpan(text: 'Ends at: '),
            new TextSpan(
                text: '$result',
                style: new TextStyle(fontWeight: FontWeight.bold)),
          ]),
    );
    return text;
  }

  // checks if there is any time on the clock 
  bool isValidTime() => _duration > Duration.zero; 
}
