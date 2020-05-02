import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
            RaisedButton(
              child: Text("Presets"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance().then((value) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PresetsModal(prefs: value);
                    }
                  );
                });
              }
            ),
            // the end time
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(getEndTimeString(), style: TextStyle(color: Colors.white, fontSize: 20))
                )
              ]
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
    result += ":" + _endTime.minute.toString().padLeft(2, "0") + timeMarker; 
    return result; 
  }

  // checks if there is any time on the clock 
  bool isValidTime() => _duration.inMinutes > Duration(minutes: 0).inMinutes; 
}

class PresetsModal extends StatefulWidget {
  PresetsModal({Key key, @required this.prefs}) : super(key: key);

  final SharedPreferences prefs;

  @override
  _PresetsModalState createState() => _PresetsModalState(prefs: prefs);
}

class _PresetsModalState extends State<PresetsModal> {
  _PresetsModalState({Key key, @required this.prefs}) : super();

  final SharedPreferences prefs;

  // Returns the number of hours from a Duration of hours and minutes
  int parseHours(String time) {
    int colonPos = time.indexOf(":");
    int hours = int.parse(time.substring(0, colonPos));
    return hours;
  }

  // Returns the number of minutes from a Duration of hours and minutes
  int parseMinutes(String time) {
    int colonPos = time.indexOf(":");
    int minutes = int.parse(time.substring(colonPos+1, colonPos+3));
    return minutes;
  }

  // Returns the number of seconds from a Duration of hours and minutes
  int parseSeconds(String time) {
    int colonPos = time.indexOf(":");
    int seconds = int.parse(time.substring(colonPos+4, colonPos+6));
    return seconds;
  }

  @override
  Widget build(BuildContext context) {

    List<String> presets = prefs.getStringList("presets");

    return AlertDialog(
      title: Text("Timer Presets"),
      content: Container(
        height: 300,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black))
        ),
        child: SingleChildScrollView(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: presets.length,
            itemBuilder: (context, index) {
              dynamic thisPreset = json.decode(presets[index]);
              int numOfTasks = thisPreset["tasks"].length;
              int hours = 0;
              int minutes = 0;
              int seconds = 0;
              for (var task in thisPreset["tasks"]) {
                hours += parseHours(task["time"]);
                minutes += parseMinutes(task["time"]);
                seconds += parseSeconds(task["time"]);
              }
              String tasks = numOfTasks.toString() + " task" + (numOfTasks == 1 ? "." : "s.");
              String time = "Total duration: " + hours.toString() + ":" + minutes.toString() + ":" + seconds.toString();
              String subtitle = tasks + " " + time;

              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  color:Colors.red,
                  child: ListTile(
                    leading: Icon(Icons.delete_forever, color: Colors.black),
                    trailing: Icon(Icons.delete_forever, color: Colors.black)
                  ),
                ),
                child: ListTile(
                  title: Text(thisPreset["name"]),
                  subtitle: Text(subtitle),
                  onTap: () {
                    // make this the current tasks
                  },
                ),
                onDismissed: (direction) {
                  setState(() {
                    presets.removeAt(index);
                    prefs.setStringList("presets", presets); 
                  });
                },
              );
            },
            separatorBuilder: (context, index) => Divider(color: Colors.black),
          )
        ),
      )
    );
  }
}
