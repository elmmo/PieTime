import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'SettingsModal.dart';
import 'timer_face/PieTimer.dart';
import 'tasks/BottomDrawer.dart';
import 'timer_face/Util.dart';
import 'TimeKeeper.dart';
import 'tasks/TaskList.dart';
import 'timer_face/NewPresetModal.dart';

// static functions meant to be used across the app, non-static functions are for 
// pages that require the main timer and task drawer (should only be home)
class OrgComponents extends StatelessWidget {
  OrgComponents({Key key, this.callback}) : super(key: key);

  final Function callback;

  Widget build(BuildContext context) {
    Duration time = TimeKeeper.of(context).time; 
    return Scaffold(
      drawer: generateSideDrawer(), 
      appBar: generateAppBar(context), 
      // Contains everything below the Appbar
      backgroundColor: Colors.grey[800],
      body: generateAppBody(time),
    );
  }

  // Hamburger menu on the Appbar to the left
  static Widget generateSideDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // header
          DrawerHeader(
            child: Text(
              'Drawer Header',
              style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Colors.grey[800],
            ),
          ),
          // items within menu
          ListTile(
            title: Text('Item 1'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // standard app bar across PieTime
  static AppBar generateAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'PieTime',
        // apply the text themes from ui branch
        // style: arr.apply()
      ),
      backgroundColor: Colors.grey[900],
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
                }
              );
            }
          }
        ),
        // Gear icon on the Appbar to the right
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            return showDialog(
              context: context,
              builder: (context) {
                return SettingsModal();
              }
            );
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          // Plus icon on the Appbar to the right
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/setTime');
            }
          )
        ),
      ],
    );
  }

    // everything below the app bar on the main page
  Widget generateAppBody(Duration time) {
    Map<String, double> dataMap = new Map();
    dataMap.putIfAbsent("Mobile Apps Mockings", () => 10);
    dataMap.putIfAbsent("Graphic Design Sketch", () => 15);
    dataMap.putIfAbsent("Core 250 RR", () => 10);

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 120.0, top:40),
          // Dotted border for each hour tick mark
          child: drawDottedBorder([
            // timer circle 
            PieChart(
              dataMap: dataMap,
              showLegends: false,
              // showChartValueLabel: true,
              animationDuration: Duration(milliseconds: 0),
              initialAngle: 4.7, //If timer moves clockwise
              showChartValuesInPercentage: false,
              chartValueStyle: defaultChartValueStyle.copyWith(
                color: Colors.blueGrey[900].withOpacity(0.9),
                fontSize: 20,
              ),
            ),
            new PieTimer(time),  // PIE TIMER 
          ],
        )),
        new BottomDrawer(callback: callback)     // BOTTOM DRAWER 
      ],
    );
  }
}

