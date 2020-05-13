import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'timer_face/PieTimer.dart';
import 'tasks/BottomDrawer.dart';
import 'theme.dart';
import 'TimeKeeper.dart';

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
            ),
            decoration: BoxDecoration(
              color: CustomColor.red[500],
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
      ),
      // backgroundColor: theme.primaryColorDark,
      // backgroundColor: theme.accentColor,
      actions: <Widget>[
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

  // everything below the app bar on the main page
  Widget generateAppBody(Duration time) {
    // TODO: Needs to obtain task list info
    Map<String, double> dataMap = new Map();
    dataMap.putIfAbsent("Mobile Apps Mockings", () => 10);
    dataMap.putIfAbsent("Graphic Design Sketch", () => 15);
    dataMap.putIfAbsent("Core 250 RR", () => 10);
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
                    dataMap: dataMap,
                    showLegends: false,
                    showChartValueLabel: false,
                    animationDuration: Duration(milliseconds: 0),
                    initialAngle: 4.713, //If timer moves clockwise
                    showChartValuesInPercentage: false,
                    colorList: colorList,
                    chartValueStyle: defaultChartValueStyle.copyWith(
                      color: Colors.blueGrey[900].withOpacity(0.0),
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
        new BottomDrawer() // BOTTOM DRAWER
      ],
    );
  }
}
