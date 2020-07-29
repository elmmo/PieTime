import 'package:flutter/material.dart';
import '../tasks/TaskList.dart';
import 'dto/ControllerDTO.dart';

class SetupController {
  final BuildContext originalContext; 
  final Function timeUpdateCallback; 
  final Function taskUpdateCallback;
  Duration time; 
  TaskList tasklist; 

  SetupController(this.originalContext, this.timeUpdateCallback, this.taskUpdateCallback); 

  void setup() {
    next("/setTime"); 
  }

  // goes to the page passed as a param 
  void next(String route) {
    Navigator.pushNamed<dynamic>(originalContext, route, arguments: ControllerDTO(this)); 
  }

  // both set time and send time need to be used to send time back to timekeeper 
  // both set tasks and send tasks need to be used to send time back to dao

  void setTime(Duration time) {
    this.time = time; 
  }

  void sendTimeToDAO() {
    timeUpdateCallback(this.time); 
  }

  void setTasks(TaskList list) {
    this.tasklist = list; 
  }

  void sendTasksToDAO() {
    taskUpdateCallback(this.tasklist); 
  }

  // app bar specific to the setup process 
  // @param titleText: what the name of the page should be 
  AppBar getSetupAppBar(String titleText, {Function closeCallback}) {
    return AppBar(
      title: Text(titleText), 
    );
  }
}