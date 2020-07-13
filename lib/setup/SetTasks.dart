import 'package:flutter/material.dart';
import '../tasks/TaskList.dart';

class SetTasks extends StatefulWidget {

  @override
  _SetTasksState createState() => new _SetTasksState();
}

class _SetTasksState extends State<SetTasks> {
  TaskList _tasks = new TaskList(); 
  final String routeName = '/setTasks'; 

  @override
  Widget build(BuildContext context) {
    final Object args = ModalRoute.of(context).settings.arguments; 
    print(args); // returns {time: 0:25:00.000000}
    return new Scaffold(
      appBar: AppBar(
        // Changes plus icon to close and goes back to home
        title: Text(
          'New Time',
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              // Plus icon on the Appbar to the right
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
        ],
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[Text("This is how you know it's working and not just total garbage")]
        ),
      ),
    );
  }
}