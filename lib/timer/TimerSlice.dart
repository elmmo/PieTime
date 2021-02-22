import 'package:flutter/material.dart';
import '../util/Theme.dart';
import 'package:fl_chart/fl_chart.dart';
import '../tasks/TaskList.dart';
import '../DAO.dart';

/* 
TimerSlice.dart houses getChartSections, which takes the context and timer duration
and returns a list of <PieChartSectionData> that PieChart uses for 
each timer slice. 
*/

// Turns tasks from tasklist into a list of slices, which is used by pie chart
// Needs context for tasklist and duration to calculate time not used by tasks
List<PieChartSectionData> getChartSections(
    BuildContext context, Duration duration) {
  TaskList taskList = DAO.of(context).taskList;
  int listLength = taskList.getLength(); //list length
  double timeTotal = duration.inSeconds.toDouble();
  Duration timeUsed = Duration.zero;

  List<PieChartSectionData> sectionData = [];
  double sliceRadius = 169.7; // (Try 144 if too big)
  double positionOffset = .65; // Distance of labels from center
  var titleTextStyle = new TextStyle(
      fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black54);

  if (listLength > 1) {
    for (int i = 0; i < listLength; i++) {
      // Don't add "New Task" from tasklist used for adding tasks
      if (taskList.getTaskAt(i).time == null ||
          taskList.getTaskAt(i).time.inSeconds <= 0) {
        continue;
      } else {
        double timeSlice = taskList.getTaskAt(i).time.inSeconds.toDouble();
        String timeSliceString = formatDuration(taskList.getTaskAt(i).time);
        String name = truncateWithEllipsis(10, taskList.getTaskAt(i).title);
        sectionData.add(PieChartSectionData(
            color: taskList.getTaskAt(i).color,
            value: timeSlice,
            title: name + "\n" + timeSliceString,
            radius: sliceRadius,
            titlePositionPercentageOffset: positionOffset,
            titleStyle: titleTextStyle));
        timeUsed += taskList.getTaskAt(i).time;
      }
    }
  }

  if (duration > timeUsed && listLength > 1) {
    sectionData.add(PieChartSectionData(
      color: CustomColor.remainder,
      value: timeTotal - timeUsed.inSeconds.toDouble(),
      title: "leftover" + "\n" + formatDuration(duration - timeUsed),
      radius: sliceRadius,
      titlePositionPercentageOffset: positionOffset,
      titleStyle: titleTextStyle,
    ));
  } else {
    // If TaskList is empty, add untitled default
    sectionData.add(PieChartSectionData(
        color: CustomColor.defaultColor,
        value: .05,
        title: "",
        radius: sliceRadius,
        titlePositionPercentageOffset: positionOffset,
        titleStyle: titleTextStyle));
  }
  List<PieChartSectionData> reversedData = new List.from(sectionData.reversed);
  return reversedData;
}

// Shortens lengthly titles
String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

// Formats duration.ToString() to hh:mm:ss
String formatDuration(Duration d) {
  var strList = d.toString().split(':');
  String last = strList.last;
  strList.removeLast();
  // Get rid of millisecond zeroes
  strList.add(last.split('.')[0]);
  String s;
  // If duration is at least an hour, hh:mm:ss
  if (Duration(hours: 1) <= d) {
    s = strList.join(':');
    return s;
    // Less than an hour, omit leading zeroes; mm:ss
  } else {
    strList.removeAt(0);
    // If duration is under ten minutes, m:ss
    if (Duration(minutes: 10) > d) {
      s = strList.join(':');
      s = s.substring(1, 5);
    } else {
      s = strList.join(':');
    }
    return s;
  }
}
