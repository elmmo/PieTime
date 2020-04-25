import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'timer_face/PieTimer.dart';
import 'BottomDrawer.dart';
import 'timer_face/Util.dart';

class OrgComponents {
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
  static Widget generateAppBar() {
    return AppBar(
      title: Text(
        'PieTime',
        // apply the text themes from ui branch
        // style: arr.apply(),
      ),
      backgroundColor: Colors.grey[900],
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          // Plus icon on the Appbar to the right
          child: IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Start new timer',
            onPressed: () {
              print("Hello World");
            }
          )
        ),
      ],
    );
  }

  // everything below the app bar on the main page
  static Widget generateAppBody(ThemeData theme) {
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
            PieTimer(0, 0, 10),
          ],
        )),
        BottomDrawer(0,0,10)
      ],
    );
  }
}
