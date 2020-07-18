import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'SettingsModal.dart';
import 'timer_face/PieTimer.dart';
import 'tasks/BottomDrawer.dart';
import 'DAO.dart';
import 'tasks/TaskList.dart';
import 'setup/SetupController.dart';
import 'timer_face/NewPresetModal.dart';
import 'timer_face/timerSlice.dart';

class Layout extends StatelessWidget {
  Layout({Key key, this.timeUpdateCallback, this.taskUpdateCallback}) : super(key: key);

  final Function timeUpdateCallback; 
  final Function taskUpdateCallback;

  Widget build(BuildContext context) {
    Duration time = DAO.of(context).time;
    List<PieChartSectionData> pieSlices = getChartSections(context, time);
    return Scaffold(
      appBar: generateAppBar(context),
      backgroundColor: Theme.of(context).canvasColor,
      body: generateAppBody(time, pieSlices),
    );
  }

  AppBar generateAppBar(BuildContext context) {
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
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (DAO.of(context) != null) {
                TaskList taskList = DAO.of(context).taskList;
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
                  SetupController setupController = new SetupController(context, timeUpdateCallback, taskUpdateCallback);
                  setupController.setup();
                })),
      ],
    );
  }

  // everything below the app bar on the main page
  Widget generateAppBody(Duration time, List<PieChartSectionData> taskMap) {
    double padTimer = 7.9;
    double timerSidePadding = 20;

    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(
                bottom: 145.0, right: timerSidePadding, left: timerSidePadding),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/TickMarks.png'),
                ),
                Align(
                  alignment: Alignment.center,
                  child: PieChart(PieChartData(
                    sections: taskMap,
                    centerSpaceRadius: 0,
                    startDegreeOffset: 270,
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                  )),
                ),
                Padding(
                  padding: EdgeInsets.all(padTimer),
                  child: new PieTimer(time), // PIE TIMER
                )
              ],
            )),
        new BottomDrawer(callback: taskUpdateCallback) // BOTTOM DRAWER
      ],
    );
  }
}
