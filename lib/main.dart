import 'package:flutter/material.dart';
import 'OrgComponents.dart';
import 'theme.dart';
import 'setup/SetTime.dart';
import 'tasks/TaskList.dart';
import 'setup/SetupController.dart';
import 'setup/AddTasks.dart';
import 'TimeKeeper.dart';

void main() => runApp(
  CustomTheme(
    initialThemeKey: MyThemeKeys.DARK,
    child: new PieTimerApp(),
  ),
);

class PieTimerApp extends StatefulWidget {
  @override
  State createState() => new _PieTimerAppState();
}

// entry for the rest of the app
class _PieTimerAppState extends State<PieTimerApp> {
  Duration _maxTime = Duration.zero;
  TaskList _taskList = new TaskList();

  Widget build(BuildContext context) {
    _taskList.maxTime = Duration.zero;
    if (_taskList.getLength() == 0) {
      // _taskList.createAddButton();
    }

    return MaterialApp(
        title: "Pie Timer",
        theme: CustomTheme.of(context),
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (BuildContext context) => 
              TimeKeeper(_maxTime, _taskList, child: OrgComponents(callback: _updateTaskList)),
          "/setTime": (BuildContext context) =>
              SetTime(),
          "/setTasks": (BuildContext context) => 
              SetTasks(),
        });
  }

  // callback for transferring duration across classes
  void _sendDuration(Duration newTime, BuildContext context) {
    if (_maxTime != Duration.zero && _taskList.list.length != 0) {
      _taskList.list.forEach((key, value) {
        if (value.percentage != null) {
          value.update(true, newTime: Duration(minutes: (newTime.inMinutes * value.percentage).floor()));
        }
      });
    }
    setState(() {
      _maxTime = newTime;
    });
  }

  // callback for transferring tasklist across classes
  void _updateTaskList(TaskList list) {
    setState(() {
      _taskList = list;
    });
  }
}