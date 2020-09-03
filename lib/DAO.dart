import 'package:flutter/material.dart';
import 'tasks/TaskList.dart';

class DAO extends InheritedWidget {
  final Duration time; 
  final TaskList taskList; 

  DAO(this.time, this.taskList, {Widget child}) : super(child: child); 

  @override 
  bool updateShouldNotify(DAO old) => 
    time != old.time; 

  static DAO of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DAO>(); 
  }
}