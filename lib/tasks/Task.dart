import 'package:flutter/material.dart';

class Task {
  final int id; 
  final Function timeCheck; 
  String title;
  Duration time; 
  bool completed;
  bool isNew; 
  Color color;

  Task(this.id, this.timeCheck) {
    this.title = "New Task";
    this.completed = false; 
    this.isNew = true; 
  }

  // verified will check if the time has been approved or not 
  // update must go through the checking process of tasklist because duration can change 
  bool update(bool verified, {String newTitle, Duration newTime, bool isComplete, Color newColor}) {
    if (!verified && time != null && timeCheck()) {
      return false; 
    }
    if (newTitle != null) title = newTitle;
    if (newTime != null) {
      time = newTime; 
      isNew = false; 
    }
    if (isComplete != null) completed = isComplete; 
    if (newColor != null) color = newColor; 
    return true; 
  }
}