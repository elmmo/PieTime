import 'package:flutter/material.dart';
import 'Task.dart';
import '../Theme.dart';

class TaskList {
  Map<int, Task> list;
  Duration maxTime;
  Duration timeUsed;
  int id;

  // colors - assigned color will be overriden if user sets task colors individually
  Color newItemColor = CustomColor.newTask;
  //   static const Color newTask = Color.fromRGBO(45, 225, 194, 1); // the color used for the "new item" card
  Color defaultColor = CustomColor.defaultColor;

  static int colorValue = 300; //Increment by 100 to change shade
  List<Color> sliceColors = [
    //Colors for task slices
    CustomColor.red[colorValue],
    CustomColor.purple[colorValue],
    CustomColor.blue[colorValue],
    CustomColor.green[colorValue],
    CustomColor.orange[colorValue],
    CustomColor.pink[colorValue],
  ];

  TaskList() {
    maxTime = Duration.zero;
    list = new Map<int, Task>();
    timeUsed = Duration.zero;
    id = 0; // for assigning id to tasks
  }

  int getLength() => list.length;

  void setMaxTime(Duration time) {
    maxTime = time;
  }

  void createAddButton() {
    list[id] = new Task(id, null);
    list[id].update(true, newTitle: "New Task", newColor: newItemColor);
    id++;
  }

  // adds task and returns whether it succeeded or not
  bool addTask(String title, {Duration time}) {
    Task newestTask = list[list.length - 1];
    // remove status as the "new item" card
    newestTask.isNew = false;
    newestTask.update(true, newColor: getDefaultColor());
    // set task specifications
    newestTask.update(true, newTitle: title);
    if (time == null) {
      return true;
    } else if (isTimeValid(time)) {
      list[list.length - 1].update(true, newTime: time);
      timeUsed += time;
      return true;
    }
    return false;
  }

  // updates a given task based on its id after checking time (if time set)
  bool updateTask(
      {Task task,
      String title,
      Duration newTime,
      bool isComplete,
      Color newColor}) {
    if (task == null) return false;
    if (newColor != null) {
      task.update(true, newColor: newColor);
    } else if (task.isNew) {
      // if task is newly updated
      task.update(true, newColor: getDefaultColor());
    }
    if (newTime != null) {
      if (isTimeValid(newTime)) {
        task.update(true, newTime: newTime);
        timeUsed += newTime;
      } else {
        // if requested duration is greater than the set time
        return false;
      }
    }
    if (title != null) {
      task.update(true, newTitle: title);
    }
    if (isComplete != null) {
      task.update(true, isComplete: isComplete);
    }
    return true;
  }

  // deletes the given task by id
  void deleteTaskById(int id) {
    timeUsed -= list[id].time;
    list.remove(id);
  }

  // deletes the given task by the task itself
  void deleteTask(Task task) {
    deleteTaskById(task.id);
  }

  void clear() {
    list.clear(); 
    createAddButton(); 
  }

  // returns a task at the value index provided
  Task getTaskAt(int index) {
    if (index < list.length) return list.values.elementAt(index);
    return null;
  }

  bool isTimeValid(Duration t) => (timeUsed + t <= maxTime);

  Color getDefaultColor() {
    int count = list.length - 1;
    int maxCount = sliceColors.length;

    for (int i = 0; i <= count; i++) {
      if (i == count) {
        return sliceColors[i % maxCount];
      }
    }
    return null;
  }
}
