import 'package:flutter/material.dart';
import 'tasks/TaskList.dart';

class TimeKeeper extends InheritedWidget {
  final Duration time; 
  final TaskList taskList;
  final Function setDurationCallback; 

  TimeKeeper(this.time, this.taskList, this.setDurationCallback, {Widget child}) : super(child: child); 

  @override 
  bool updateShouldNotify(TimeKeeper old) => 
    time != old.time; 

  static TimeKeeper of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TimeKeeper>(); 
  }
}