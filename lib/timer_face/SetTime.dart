import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../tasks/TaskList.dart';
// import '../tasks/Task.dart';
import '../OrgComponents.dart';

class SetTime extends StatefulWidget {
  final Function durationCallback; 
  final Function taskListCallback;
  final TaskList taskList;
  final BuildContext originalContext; 
  
  SetTime(this.durationCallback, this.taskListCallback, this.taskList, this.originalContext);

  @override
  _SetTimeState createState() => new _SetTimeState(taskList: taskList);
}

class _SetTimeState extends State<SetTime> {
  _SetTimeState({Key key, this.taskList}) : super();
  final TaskList taskList;

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
            // choose from presets
            RaisedButton(
              child: Text("Presets"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final presetDuration = await showDialog(
                  context: context,
                  builder: (context) {
                    return PresetsModal(
                      durationCallback: this.widget.durationCallback,
                      taskListCallback: this.widget.taskListCallback,
                      originalContext: this.widget.originalContext,
                      prefs: prefs
                    );
                  }
                ) as Duration;
                if (presetDuration != null) {
                  setState(() {
                    _duration = presetDuration;
                    setEndTime();
                  });
                }
              }
            ),
            // the end time
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: getEndTimeString()
                  )
              ]
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
                    this.widget.durationCallback(_duration, this.widget.originalContext); 
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

class PresetsModal extends StatefulWidget {
  PresetsModal({Key key, @required this.durationCallback, @required this.taskListCallback, @required this.originalContext, @required this.prefs}) : super(key: key);

  final Function durationCallback;
  final Function taskListCallback;
  final BuildContext originalContext;
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
    if (presets == null) {
      presets = [];
    }

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
              Duration duration = Duration(hours: hours, minutes: minutes, seconds: seconds);
              String tasks = numOfTasks.toString() + " task" + (numOfTasks == 1 ? "." : "s.");
              String time = "Total duration: " + hours.toString() + ":" + minutes.toString() + ":" + seconds.toString();
              String subtitle = tasks + " " + time;

              TaskList taskListFromPreset = new TaskList();
              taskListFromPreset.maxTime = duration;
              for (var i = 0; i < thisPreset["tasks"].length; i++) {
                Map task = thisPreset["tasks"][i];
                taskListFromPreset.createAddButton();
                Duration taskDuration = Duration(hours: parseHours(task["time"]), minutes: parseMinutes(task["time"]), seconds: parseSeconds(task["time"]));
                taskListFromPreset.addTask(task["title"], time: taskDuration);
              }
              taskListFromPreset.createAddButton();

              // checks if there is any time on the clock 
              bool isValidTime() => duration > Duration.zero;

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
                    Navigator.pop(context, Duration(hours: hours, minutes: minutes, seconds: seconds));
                    if (isValidTime()) {
                      this.widget.durationCallback(duration, this.widget.originalContext); 
                    }
                    this.widget.taskListCallback(taskListFromPreset);
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
