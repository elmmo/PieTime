import 'package:flutter/material.dart';
import 'OrgComponents.dart';
import 'theme.dart';
import 'timer_face/SetTime.dart';
import 'tasks/TaskList.dart';
import 'TimeKeeper.dart';

void main() => runApp(
      CustomTheme(
        initialThemeKey: MyThemeKeys.DARK,
        child: new PieTimerApp()),
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
      _taskList.createAddButton();
    }

    return MaterialApp(
        title: "Pie Timer",
        theme: CustomTheme.of(context),
        routes: {
          '/setTime': (BuildContext context) =>
              SetTime(_sendDuration, _updateTaskList, _taskList, context),
        },
        home: Builder(
            builder: (context) => TimeKeeper(_maxTime, _taskList,
                child: OrgComponents(callback: _updateTaskList))));
  }

  // callback for transferring duration across classes
  void _sendDuration(Duration newTime, BuildContext context) {
    setState(() {
      _maxTime = newTime;
    });
    Navigator.pop(context);
  }

  // callback for transferring tasklist across classes
  void _updateTaskList(TaskList list) {
    setState(() {
      _taskList = list;
    });
  }
}