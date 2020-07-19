import 'package:flutter/material.dart';
import 'dart:convert';
import '../tasks/TaskList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PresetsModal extends StatefulWidget {
  PresetsModal(
      {Key key,
      @required this.durationCallback,
      @required this.taskListCallback,
      @required this.originalContext,
      @required this.prefs})
      : super(key: key);

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
    int minutes = int.parse(time.substring(colonPos + 1, colonPos + 3));
    return minutes;
  }

  // Returns the number of seconds from a Duration of hours and minutes
  int parseSeconds(String time) {
    int colonPos = time.indexOf(":");
    int seconds = int.parse(time.substring(colonPos + 4, colonPos + 6));
    return seconds;
  }

  @override
  Widget build(BuildContext context) {
    List<String> presets = prefs.getStringList("presets");
    if (presets == null) {
      presets = [];
    }

    return AlertDialog(
        // contentTextStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
        titleTextStyle: Theme.of(context).textTheme.headline5,
        title: Text("Timer Presets"),
        content: Container(
            height: 300,
            width: double.maxFinite,
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Theme.of(context).textTheme.bodyText1.color))),
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
                Duration duration =
                    Duration(hours: hours, minutes: minutes, seconds: seconds);
                String tasks = numOfTasks.toString() +
                    " task" +
                    (numOfTasks == 1 ? "." : "s.");
                String time = "Total duration: " +
                    hours.toString() +
                    ":" +
                    minutes.toString() +
                    ":" +
                    seconds.toString();
                String subtitle = tasks + " " + time;
                TaskList taskListFromPreset = new TaskList();
                taskListFromPreset.maxTime = duration;
                for (var i = 0; i < thisPreset["tasks"].length; i++) {
                  Map task = thisPreset["tasks"][i];
                  taskListFromPreset.createAddButton();
                  Duration taskDuration = Duration(
                      hours: parseHours(task["time"]),
                      minutes: parseMinutes(task["time"]),
                      seconds: parseSeconds(task["time"]));
                  taskListFromPreset.addTask(task["title"], time: taskDuration);
                }
                taskListFromPreset.createAddButton();

                // checks if there is any time on the clock
                bool isValidTime() => duration > Duration.zero;

                // Swipe to delete preset item
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Theme.of(context).errorColor,
                    child: ListTile(
                        leading:
                            Icon(Icons.delete_forever, color: Colors.white),
                        title: Text('Delete', style: TextStyle(color: Colors.white)),
                        trailing:
                            Icon(Icons.delete_forever, color: Colors.white)),
                  ),
                  child: ListTile(
                    title: Text(thisPreset["name"],
                        style: Theme.of(context).textTheme.bodyText1),
                    subtitle: Text(subtitle,
                        style: Theme.of(context).textTheme.bodyText2),
                    onTap: () {
                      Navigator.pop(
                          context,
                          Duration(
                              hours: hours,
                              minutes: minutes,
                              seconds: seconds));
                      if (isValidTime()) {
                        this.widget.durationCallback(
                            duration, this.widget.originalContext);
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
              separatorBuilder: (context, index) =>
                  Divider(color: Theme.of(context).textTheme.bodyText1.color),
            )));
  }
}