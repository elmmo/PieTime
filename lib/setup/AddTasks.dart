import 'package:flutter/material.dart';
import '../tasks/TaskList.dart';
import 'dto/ControllerDTO.dart';

class SetTasks extends StatefulWidget {

  @override
  _SetTasksState createState() => new _SetTasksState();
}

class _SetTasksState extends State<SetTasks> {
  TaskList _tasks = new TaskList(); 

  @override
  Widget build(BuildContext context) {
    final ControllerDTO dto = ModalRoute.of(context).settings.arguments; 
    return new Scaffold(
      appBar: dto.controller.getSetupAppBar("Add Tasks"), 
      body: new Center(
        child: new Column(
          children: <Widget>[
            Text("If you see this on the new page, it's working"),
            FlatButton(
              color: Colors.blue, 
              textColor: Colors.white, 
              child: Text("ok got it"), 
              padding: EdgeInsets.all(8.0), 
              onPressed: () {
                
                // TODO: add tasklist logic that builds out the list, replace the mock with that 

                TaskList list = new TaskList();
                Navigator.pop(context, list); 

              }
            )
          ]
        ),
      ),
    );
  }
}