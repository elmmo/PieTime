import 'package:flutter/material.dart';

class TimeKeeper extends InheritedWidget {
  final Duration time; 

  TimeKeeper(this.time, {Widget child}) : super(child: child); 

  @override 
  bool updateShouldNotify(TimeKeeper old) => 
    time != old.time; 

  static TimeKeeper of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TimeKeeper>(); 
  }
}