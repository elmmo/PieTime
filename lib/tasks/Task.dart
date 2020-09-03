import 'package:flutter/material.dart';
import '../util/theme.dart';

int colorValue = 300; //Increment by 100 to change shade
List<Color> sliceColors = [
  //Colors for task slices
  CustomColor.red[colorValue],
  CustomColor.purple[colorValue],
  CustomColor.blue[colorValue],
  CustomColor.green[colorValue],
  CustomColor.orange[colorValue],
  CustomColor.pink[colorValue],
];

class Task {
  String title;
  Duration time;
  double percentage;
  bool completed;
  Color color;
  bool isNew; 

  Task() {
    this.title = "New Task";
    this.completed = false;
    this.color = Color(0xffff30a0);
    this.isNew = true; 
  }

  bool update(bool verified,
      {String newTitle,
      Duration newTime,
      double newPercentage,
      bool isComplete,
      Color newColor}) {
    if (newTitle != null) title = newTitle;
    if (newTime != null) {
      time = newTime;
    }
    if (newPercentage != null) percentage = newPercentage;
    if (isComplete != null) completed = isComplete;
    if (newColor != null) color = newColor;
    return true;
  }
}