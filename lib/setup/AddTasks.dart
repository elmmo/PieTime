import 'package:flutter/material.dart';
import '../tasks/Task.dart';
import '../tasks/TaskList.dart';
import '../tasks/TaskModal.dart';
import 'dto/ControllerDTO.dart';
import '../DAO.dart';
import '../util/Util.dart';
import '../util/theme.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../presets/NewPresetModal.dart';

class AddTasks extends StatefulWidget {
  AddTasks({Key key, @required this.storeTasklistCallback}) : super(key: key);

  final Function storeTasklistCallback;

  @override
  _AddTasksState createState() => new _AddTasksState(storeTaskListCallback: storeTasklistCallback);
}

class _AddTasksState extends State<AddTasks> {
  _AddTasksState({Key key, @required this.storeTaskListCallback}) : super();

  // managing time within this screen 
  Duration maxTime; 
  Duration timeUsed = Duration.zero; 

  // managing tasklist 
  final Function storeTaskListCallback;
  TaskList _taskList = new TaskList();

  // Substitute for taskList tasks
  // create some color values
  Color pickerColor = Color(0xffff30a0);

  @override
  Widget build(BuildContext context) {
    final ControllerDTO dto = ModalRoute.of(context).settings.arguments;
    maxTime = dto.controller.time; 
    return new Scaffold(
        appBar: dto.controller.getSetupAppBar("Add Tasks"),
        body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    // Contains list of tasks
                    child: ReorderableListView(
                        header: Text(
                            "${getTimeRemaining().inMinutes} min. remaining",
                            style: TextStyle(fontSize: 20)),
                        children: List.generate(
                          _taskList.getLength(),
                          (index) {
                            return getListCard(index);
                          },
                        ),
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 35.0),
                        onReorder: (oldIndex, newIndex) {
                          // logic to reorder tasks based on where a task is moved
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            _taskList.insert(newIndex, _taskList.getTaskAt(oldIndex)); 
                          });
                        })),
                // + Add Task Button
                Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 10),
                  child: RaisedButton.icon(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).textTheme.button.color,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    color: CustomColor.colorAccent,
                    label: Text("ADD TASK",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(fontSize: 17.0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return TaskModal(
                              task: new Task(),
                              totalDuration: maxTime,
                              taskDuration: Duration.zero,
                              timeChecker: isTimeValid,
                              addTask: addTask, 
                              color: pickerColor, 
                              isUpdate: false, 
                              onUpdate: updateCard,
                              onDelete: deleteCard,
                            );
                          });
                    },
                  ),
                ),
                // Save as Preset button
                FlatButton(
                  color: Colors.transparent,
                  textColor: CustomColor.colorAccent,
                  child: Text("Save as Preset",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).textTheme.headline3.color)),
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
                // Skip/Done buttons
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        color: Colors.transparent,
                        textColor: Theme.of(context).textTheme.button.color,
                        child: Text("SKIP",
                            style: Theme.of(context).textTheme.button),
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 15.0),
                        onPressed: () {
                          _taskList.clear();
                          Navigator.popUntil(context, ModalRoute.withName("/"));
                        },
                      ),
                      FlatButton(
                          color: Colors.transparent,
                          textColor: Theme.of(context).textTheme.button.color,
                          child: Text("DONE",
                              style: Theme.of(context).textTheme.button),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          onPressed: () {
                            dto.controller.setTime(maxTime); 
                            dto.controller.sendTimeToDAO();
                            print("done"); 
                            print(_taskList); 
                            dto.controller.setTasklist(_taskList); 
                            dto.controller.sendTasksToDAO();
                            Navigator.popUntil(
                                context, ModalRoute.withName("/"));
                          }),
                    ],
                  ),
                )
              ]),
        ));
  }

  void addTask(Task t) {
    _taskList.addTask(t); 
    setState(() {
      timeUsed += _taskList.getLast().time; 
    }); 
  }

  void updateCard(
      {Task task, bool isComplete, Duration newTime, String newTitle}) {
    Duration oldTime = task.time; 
    setState(() {
      _taskList.updateTask(
        task,
        title: newTitle,
        newTime: newTime,
        isComplete: isComplete);
    });
    if (oldTime != null) {
      timeUsed -= oldTime; 
      setState(() {
        timeUsed += newTime; 
      }); 
    }
    this.widget.storeTasklistCallback(_taskList);
  }

  void deleteCard(Task task) {
    timeUsed -= task.time; 
    setState(() {
      _taskList.remove(task); 
    });
    this.widget.storeTasklistCallback(_taskList);
    print(_taskList.maxTime);
  }

  void deleteCardByIndex(int index) {
    timeUsed -= _taskList.getTaskAt(index).time; 
    setState(() {
      _taskList.removeAt(index); 
    });
    this.widget.storeTasklistCallback(_taskList);
    print(_taskList.maxTime);
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  // Dialog that appears when color tile is tapped
  void showColorPicker(BuildContext context, int index) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            // Default color picker
            child: ColorPicker(
              pickerColor: _taskList.orderedTasks[index].color,
              onColorChanged: changeColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 5),
                child: FlatButton(
                    child: const Text('DONE'),
                    onPressed: () {
                      setState(() =>
                          _taskList.orderedTasks[index].color = pickerColor);
                      Navigator.of(context).pop();
                      // TODO: make picker color of each task match the tasks's current color
                      // So that when opened, the color displayed on the picker matches the current tasks's color
                    })),
          ],
        ));
  }

  // Contains the contents for each task on the list
  Widget getListCard(int index) {
    Task task = _taskList.getTaskAt(index); 
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      key: Key('$index'),
      color: Theme.of(context).canvasColor,
      child: InkWell(
          splashColor: Theme.of(context).splashColor,
          onTap: () {
            // Edit task when task card is tapped. Currently incompatible with Task 
            showDialog(
                context: context,
                builder: (context) {
                  return TaskModal(
                    task: task,
                    totalDuration: maxTime,
                    taskDuration: task.time,
                    addTask: addTask, 
                    timeChecker: isTimeValid,
                    // TO DO: change color on this 
                    color: Colors.red,
                    isUpdate: true, 
                    onUpdate: updateCard,
                    onDelete: deleteCard,
                  );
                });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Delete icon button
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      deleteCardByIndex(index); 
                    }),
              ),
              // Color picker tile
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    color: _taskList.getTaskAt(index).color,
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.only(right: 18),
                child: InkWell(onTap: () {
                  showColorPicker(context, index);
                }),
              ),
              // Title and Duration
              Flexible(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 2.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${_taskList.getTaskAt(index).title}',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.left,
                    maxLines: 5,
                  ),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${_taskList.getTaskAt(index).time.inMinutes.toString()} min.',
                      style: Theme.of(context).textTheme.subtitle2,
                    )),
              ])),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Icon(
                    Icons.drag_handle,
                    color: Colors.grey,
                    size: 24.0,
                  ))
            ],
          )),
    );
  }

  bool isTimeValid(Duration t, bool isUpdate, Task task) {
    if (isUpdate && task != null) {
      print('timeUsed: ${timeUsed}'); 
      print('task time: ${task.time}'); 
      print('t: ${t}'); 
      print('maxTime: ${maxTime}'); 
      return timeUsed - task.time + t <= maxTime; 
    } else {
      return timeUsed + t <= maxTime; 
    }
  }

  Duration getTimeRemaining() {
    if (maxTime != null && maxTime is Duration && timeUsed != null && timeUsed is Duration) 
    {
      return maxTime - timeUsed; 
    } else {
      print("Error calculating getTimeRemaining() in AddTasks"); 
      print('MaxTime: ${maxTime} | should not be null'); 
      print('MaxTime: ${maxTime is Duration} | should be true'); 
      print('TimeUsed: ${timeUsed} | should not be null'); 
      print('MaxTime: ${timeUsed is Duration} | should be true'); 
      return Duration.zero; 
    }
  }
}
