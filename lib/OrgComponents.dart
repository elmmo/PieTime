import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'SettingsModal.dart';
import 'timer_face/PieTimer.dart';
import 'tasks/BottomDrawer.dart';
import 'theme.dart';
import 'TimeKeeper.dart';
import 'tasks/TaskList.dart';
import 'timer_face/NewPresetModal.dart';

// static functions meant to be used across the app, non-static functions are for
// pages that require the main timer and task drawer (should only be home)
class OrgComponents extends StatelessWidget {
  static int colorValue = 400; //Increment by 100 to change shade
  List<Color> colorList = [
    //Colors for task slices
    CustomColor.red[colorValue],
    CustomColor.purple[colorValue],
    CustomColor.blue[colorValue],
    CustomColor.green[colorValue],
    CustomColor.orange[colorValue],
    CustomColor.pink[colorValue],
  ];

  OrgComponents({Key key, this.callback}) : super(key: key);

  final Function callback;

  Widget build(BuildContext context) {
    Duration time = TimeKeeper.of(context).time;
    Map<String, double> pieSlices = getChartValues(context, time);
    return Scaffold(
      // drawer: generateSideDrawer(),
      appBar: generateAppBar(context),
      // Contains everything below the Appbar
      backgroundColor: Colors.grey[800],
      body: generateAppBody(time, pieSlices),
    );
  }

  // standard app bar across PieTime
  static AppBar generateAppBar(BuildContext context) {
    return AppBar(
      leading: // Gear icon on the Appbar to the right
          IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          return showDialog(
              context: context,
              builder: (context) {
                return SettingsModal();
              });
        },
      ),
      title: Text(
        'PieTime',
      ),
      // backgroundColor: theme.primaryColorDark,
      // backgroundColor: theme.accentColor,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (TimeKeeper.of(context) != null) {
                TaskList taskList = TimeKeeper.of(context).taskList;
                showDialog(
                    context: context,
                    builder: (context) {
                      return NewPresetModal(taskList: taskList);
                    });
              }
            }),
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            // Plus icon on the Appbar to the right
            child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(context, '/setTime');
                })),
      ],
    );
  }

  // Turns tasks from tasklist into a map of slices, which is used by pie chart
  // Needs context for tasklist and duration to calculate time not used by tasks
  Map<String, double> getChartValues(BuildContext context, Duration duration) {
    TaskList taskList = TimeKeeper.of(context).taskList;
    int listLength = taskList.getLength();
    double timeTotal = duration.inMinutes.toDouble();
    double timeUsed = 0;
    final Map<String, double> dataMap = {};

    if (listLength > 0) {
      for (int i = 0; i < listLength; i++) {
        // Don't add "New Task" from tasklist used for adding tasks
        if (taskList.getTaskAt(i).time == null) {
          continue;
        } else {
          // Get task title and duration and add to pie chart dataMap
          double timeSlice = taskList.getTaskAt(i).time.inMinutes.toDouble();
          String name = taskList.getTaskAt(i).title;
          dataMap.putIfAbsent(name, () => timeSlice);
          timeUsed += timeSlice;
        }
      }
    }
    // Finds remaining time so Pie Chart can make a slice for it
    if (timeTotal > timeUsed) {
      dataMap.putIfAbsent("Remaining", () => timeTotal - timeUsed);
    } else if (timeTotal == 0.0) {
      // If TaskList is empty, add default- throws a fit otherwise
      dataMap.putIfAbsent("Default", () => 100);
    }
    return dataMap;
  }

  // everything below the app bar on the main page
  Widget generateAppBody(Duration time, Map<String, double> taskMap) {
    double padTimer = 8;
    double timerSidePadding = 20;

    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(
                bottom: 135.0, right: timerSidePadding, left: timerSidePadding),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/TickMarks.png'),
                ),
                Padding(
                  child: PieChart(
                    dataMap: taskMap,
                    showLegends: false,
                    showChartValueLabel: false,
                    animationDuration: Duration(milliseconds: 0),
                    initialAngle: 4.713, //If timer moves clockwise
                    showChartValuesInPercentage: false,
                    colorList: colorList,
                    chartValueStyle: defaultChartValueStyle.copyWith(
                      color: Colors.blueGrey[900],
                      fontSize: 20,
                    ),
                  ),
                  padding: EdgeInsets.all(padTimer),
                ),
                Padding(
                  padding: EdgeInsets.all(padTimer),
                  child: new PieTimer(time), // PIE TIMER
                )
              ],
            )),
        new BottomDrawer(callback: callback) // BOTTOM DRAWER
      ],
    );
  }
}
