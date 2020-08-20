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

  // Substitute for taskList tasks
  // create some color values
  Color pickerColor = Color(0xffff30a0);

  @override
  Widget build(BuildContext context) {
    final ControllerDTO dto = ModalRoute.of(context).settings.arguments;
    final Duration maxTime = dto.controller.time; 
    _taskList.setMaxTime(maxTime);
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
                            "${_taskList.getTimeRemaining().inMinutes} min. remaining",
                            style: TextStyle(fontSize: 20)),
                        children: List.generate(
                          _taskList.orderedTasks.length,
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
                            final replaceWidget = _taskList.orderedTasks.removeAt(oldIndex);
                            _taskList.orderedTasks.insert(newIndex, replaceWidget);
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
                      _taskList.addTask("New Task");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return TaskModal(
                              task: _taskList.orderedTasks.elementAt(_taskList.getLength()-1),
                              totalDuration: _taskList.maxTime,
                              taskDuration: task.time,
                              timeChecker: _taskList.isTimeValid,
                              color: pickerColor, 
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
                    // showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return NewPresetModal(
                    //         taskList: _taskList,
                    //       );
                    //     });
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

                            dto.controller.sendTimeToDAO();
                            // dto.controller.setTasks(_taskList);
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

  void updateCard(
      {Task task, bool isComplete, Duration newTime, String newTitle}) {
    setState(() {
      _taskList.updateTask(
          task,
          title: newTitle,
          newTime: newTime,
          isComplete: isComplete);
      this.widget.callback(_taskList);
    });
  }

  void deleteCard(Task task) {
    print("delete card called");
    setState(() {
      _taskList.remove(task); 
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
    List listItems = _taskList.orderedTasks;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      key: Key('$index'),
      color: Theme.of(context).canvasColor,
      child: InkWell(
          splashColor: Theme.of(context).splashColor,
          onTap: () {
            // Edit task when task card is tapped. Currently incompatible with Task 
            // showDialog(
            //     context: context,
            //     builder: (context) {
            //       return TaskModal(
            //         task: task,
            //         totalDuration: _taskList.maxTime,
            //         taskDuration: task.time,
            //         timeChecker: _taskList.isTimeValid,
            //         color: (task.isNew
            //             ? _taskList.newItemColor
            //             : _taskList.defaultColor),
            //         onUpdate: updateCard,
            //         onDelete: deleteCard,
            //       );
            //     });
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
                      _taskList.orderedTasks.removeAt(index);
                      setState(() {});
                    }),
              ),
              // Color picker tile
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    color: _taskList.orderedTasks[index].color,
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
                    '${listItems[index].title}',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.left,
                    maxLines: 5,
                  ),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${listItems[index].time.inMinutes.toString()} min.',
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
}
