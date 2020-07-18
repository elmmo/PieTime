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

  void setTime(Duration time) {
    this.time = time; 
    timeUpdateCallback(time);
  }

  void setTasks(TaskList list) {
    this.tasklist = list; 
    taskUpdateCallback(list); 
  }

  // app bar specific to the setup process 
  // @param titleText: what the name of the page should be 
  AppBar getSetupAppBar(String titleText) {
    return AppBar(
      title: Text(titleText), 
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0), 
          child: IconButton(
            icon: Icon(Icons.close), 
            onPressed: () {
              Navigator.popUntil(originalContext, ModalRoute.withName("/"));
            }
          )
        )
      ]
    );
  }
}