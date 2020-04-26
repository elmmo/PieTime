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
  static Widget generateAppBar([appBarBottom]) {
    return AppBar(
      title: Text(
        'PieTime',
        // apply the text themes from ui branch
        // style: arr.apply()
      ),
      bottom: appBarBottom,
      backgroundColor: Colors.grey[900],
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          // Plus icon on the Appbar to the right
          child: IconButton(
            icon: Icon(Icons.add),
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
<<<<<<< HEAD
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
            PieTimer(),
          ],
        )),
=======
          child: DottedBorder(
            color: Colors.white,
            radius: Radius.circular(10),
            dashPattern: [2, 110],
            strokeWidth: 20,
            borderType: BorderType.Circle,

            // Dotted border for each hour minute mark
            child: DottedBorder(
                color: Colors.white,
                radius: Radius.circular(12),
                dashPattern: [2.1, 20],
                strokeWidth: 8,
                borderType: BorderType.Circle,
                padding: EdgeInsets.all(6),
                // Red timer circle
                child: Stack(
                  children: <Widget>[
                    // Positioned(
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
                    PieTimer(0, 0, 5),
                    // ),
                  ],
                )),
          ),
        ),
>>>>>>> c1ee0d57f47b74168ecc248bbc89f4077d079c3a
        BottomDrawer(0,0,10)
      ],
    );
  }
}
