import 'package:flutter/material.dart';
import '../tasks/Task.dart';
import '../tasks/TaskList.dart';
import '../tasks/TaskModal.dart';
import 'dto/ControllerDTO.dart';
import '../DAO.dart';
import '../util/Util.dart';
import '../presets/NewPresetModal.dart';

class SetTasks extends StatefulWidget {
  SetTasks({Key key, @required this.callback}) : super(key: key);

  final Function callback;

  @override
  _SetTasksState createState() => new _SetTasksState(callback: callback);
}

class _SetTasksState extends State<SetTasks> {
  _SetTasksState({Key key, @required this.callback}) : super();

  final Function callback;
  TaskList _taskList = new TaskList();
  Task task = new Task(0);
  List<Task> _list = [];

  @override
  Widget build(BuildContext context) {
    if (DAO.of(context) != null) {
      final time = DAO.of(context).time;
      _taskList = DAO.of(context).taskList;
      _taskList.maxTime = time;
    }
    final ControllerDTO dto = ModalRoute.of(context).settings.arguments;
    _taskList.setMaxTime(dto.controller.time);
    return new Scaffold(
      appBar: dto.controller.getSetupAppBar("Add Tasks", closeCallback: () {
        return getTextDialog(context, "Exit",
            "Would you like to save the submitted time or exit without saving?",
            buttons: <Widget>[
              RaisedButton(
                  child: Text("Save"),
                  onPressed: () {
                    dto.controller.sendTimeToDAO();
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  }),
              OutlineButton(
                  child: Text("Exit"),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  })
            ]);
      }),
      body: new Center(
        child: new Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 60.0, right: 60.0),
            child: SizedBox(
              height: 300.0,
              width: double.infinity,
              child: ReorderableListView(
                header: Text("${_taskList.maxTime.inMinutes} min. remaining",
                    style: TextStyle(fontSize: 20)),
                children: List.generate(_list.length, (index) {
                  return ListTile(
                    title: Text(_list[index].title),
                    key: Key('$index'),
                  );
                }),
                onReorder: (oldIndex, newIndex) {
                  // logic to reorder tasks based on where a task is moved
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    var replaceWidget = _list[oldIndex];
                    _list.insert(newIndex, replaceWidget);
                  });
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: 60.0, right: 60.0, bottom: 30.0, top: 30.0),
            child: SizedBox(
              height: 50.0,
              width: double.infinity,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text("+ ADD TASK", style: TextStyle(fontSize: 20.0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return TaskModal(
                          task: task,
                          totalDuration: _taskList.maxTime,
                          taskDuration: task.time,
                          timeChecker: _taskList.isTimeValid,
                          color: (task.isNew
                              ? _taskList.newItemColor
                              : _taskList.defaultColor),
                          onUpdate: updateCard,
                          onDelete: deleteCard,
                        );
                      });
                  _list.add(_taskList.getTaskAt(_taskList.getLength() - 1));
                },
              ),
            ),
          ),
          FlatButton(
            color: Colors.transparent,
            textColor: Colors.blue[400],
            child: Text("Save as Preset", style: TextStyle(fontSize: 22.0)),
            padding: EdgeInsets.all(8.0),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return NewPresetModal(
                      taskList: _taskList,
                    );
                  });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                color: Colors.transparent,
                textColor: Colors.white,
                child: Text("SKIP", style: TextStyle(fontSize: 24.0)),
                padding: EdgeInsets.only(left: 50.0, top: 30.0),
                onPressed: () {
                  _taskList.clear();
                  Navigator.popUntil(context, ModalRoute.withName("/"));
                },
              ),
              FlatButton(
                  color: Colors.transparent,
                  textColor: Colors.white,
                  child: Text("DONE", style: TextStyle(fontSize: 24.0)),
                  padding: EdgeInsets.only(right: 50.0, top: 30.0),
                  onPressed: () {
                    //_taskList = listToTaskList(_list, _taskList);
                    dto.controller.sendTimeToDAO();
                    dto.controller.setTasks(_taskList);
                    dto.controller.sendTasksToDAO();
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  }),
            ],
          ),
        ]),
      ),
    );
  }

  void updateCard(
      {Task task, bool isComplete, Duration newTime, String newTitle}) {
    setState(() {
      _taskList.updateTask(
          task: task,
          title: newTitle,
          newTime: newTime,
          isComplete: isComplete);
      this.widget.callback(_taskList);
    });
  }

  void deleteCard(Task task) {
    setState(() {
      _taskList.deleteTask(task);
      this.widget.callback(_taskList);
    });
  }
  
  // try to figure it out without this
  TaskList listToTaskList(List<Task> list, TaskList tasks) {
    for (int i = 0; i < list.length; i++) {
      tasks.addTask(list[i].title);
    }
    return tasks;
  }
}
