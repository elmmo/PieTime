import 'package:flutter/material.dart';
import '../tasks/TaskList.dart';

class SetupController {
  BuildContext originalContext; 
  Duration time; 
  TaskList tasks; 

  SetupController(this.originalContext); 

  void setup() async {
    this.time = await Navigator.pushNamed<dynamic>(originalContext, '/setTime');
    this.tasks = await Navigator.pushNamed<dynamic>(originalContext, '/setTasks', 
      arguments: {
        'time': time
      }); 
  }

  // app bar specific to the setup process 
  // @param titleText: what the name of the page should be 
  AppBar generateSetupAppBar(String titleText) {
    return AppBar(
      title: Text(titleText), 
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0), 
          child: IconButton(
            icon: Icon(Icons.close), 
            onPressed: () {
              Navigator.pop(originalContext);
            }
          )
        )
      ]
    );
  }
}