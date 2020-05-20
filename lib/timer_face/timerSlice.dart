import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:fl_chart/fl_chart.dart';
import '../tasks/TaskList.dart';
import '../TimeKeeper.dart';

/* 
timerSlice.dart merely exists to take pressure off of OrgComponents
by housing getChartSections, which takes the context and timer duration
and returns a list of <PieChartSectionData> that PieChart uses for 
each timer slice. 
*/

  int colorValue = 300; //Increment by 100 to change shade
  List<Color> sliceColors = [ //Colors for task slices
    CustomColor.red[colorValue],
    CustomColor.purple[colorValue],
    CustomColor.blue[colorValue],
    CustomColor.green[colorValue],
    CustomColor.orange[colorValue],
    CustomColor.pink[colorValue],
  ];

// Turns tasks from tasklist into a list of slices, which is used by pie chart
// Needs context for tasklist and duration to calculate time not used by tasks
List<PieChartSectionData> getChartSections(
    BuildContext context, Duration duration) {
  TaskList taskList = TimeKeeper.of(context).taskList;
  int listLength = taskList.getLength();
  double timeTotal = duration.inMinutes.toDouble();
  double timeUsed = 0;

  final List<PieChartSectionData> sectionData = [];
  double sliceRadius = 130; //Controls how big each slice is
  var titleTextStyle = new TextStyle(
      //Styles the title of each task slice
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: Colors.black54);

  if (listLength > 0) {
    for (int i = 0; i < listLength; i++) {
      // Don't add "New Task" from tasklist used for adding tasks
      if (taskList.getTaskAt(i).time == null) {
        continue;
      } else {
        // Get task title and duration and add to pie chart dataMap
        double timeSlice = taskList.getTaskAt(i).time.inMinutes.toDouble();
        String name = truncateWithEllipsis(9, taskList.getTaskAt(i).title);
        sectionData.add(PieChartSectionData(
            color: sliceColors[i % 6],
            value: timeSlice,
            title: name + "\n" + timeSlice.toString(),
            radius: sliceRadius,
            titlePositionPercentageOffset: .7,
            titleStyle: titleTextStyle));
        timeUsed += timeSlice;
      }
    }
  }
  // Finds remaining time so Pie Chart can make a slice for it
  if (timeTotal > timeUsed && timeTotal != 0.0) {
    sectionData.add(PieChartSectionData(
      color: CustomColor.remainder,
      value: timeTotal - timeUsed,
      title: "leftover" + "\n" + (timeTotal - timeUsed).toString(),
      radius: sliceRadius,
      titleStyle: titleTextStyle,
    ));
  } else if (timeTotal == 0.0) {
    // If TaskList is empty, add untitled default
    sectionData.add(PieChartSectionData(
        color: CustomColor.remainder,
        value: 1,
        title: "",
        radius: sliceRadius,
        titleStyle: titleTextStyle));
  }
  return sectionData;
}
// Shortens lengthly titles
String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}
