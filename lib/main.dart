import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Layout.dart';
import 'util/Theme.dart';
import 'setup/SetTime.dart';
import 'tasks/TaskList.dart';
import 'tasks/Task.dart';
import 'setup/AddTasks.dart';
import 'DAO.dart';

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _taskList.maxTime = Duration.zero;

    return MaterialApp(
        title: "Pie Timer",
        theme: CustomTheme.of(context),
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (BuildContext context) => 
              DAO(_maxTime, _taskList, child: Layout(timeUpdateCallback: sendDuration, taskUpdateCallback: sendTaskList)),
          "/setTime": (BuildContext context) =>
              SetTime(),
          "/AddTasks": (BuildContext context) => 
              AddTasks(storeTasklistCallback: sendTaskList),
        });
  }

  // callback for transferring duration across classes
  void sendDuration(Duration newTime) {
    // if (_maxTime != Duration.zero && _taskList.list.length != 0) {
    //   _taskList.list.forEach((key, value) {
    //     if (value.percentage != null) {
    //       value.update(true, newTime: Duration(minutes: (newTime.inMinutes * value.percentage).floor()));
    //     }
    //   });
    // }
    setState(() {
      _maxTime = newTime;
    });
  }

  // callback for transferring tasklist across classes
  void sendTaskList(TaskList list) {
    print("sendTaskList"); 
    setState(() {
      _taskList = list;
    });
    print("this is the stored tasklist in main"); 
    print(_taskList);
  }
}