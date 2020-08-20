import 'package:flutter/material.dart';
import 'tasks/TaskList.dart';

class DAO extends InheritedWidget {
  final Duration time; 
  TaskList _taskList = new TaskList(); 

  DAO(this.time, {Widget child}) : super(child: child); 

  @override 
  bool updateShouldNotify(DAO old) => 
    time != old.time; 

  TaskList getTaskList() {
    return _taskList; 
  }

  static DAO of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DAO>(); 
  }
}