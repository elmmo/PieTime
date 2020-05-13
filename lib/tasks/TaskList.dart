import 'package:flutter/material.dart';
import 'Task.dart';

class TaskList {
  Map<int, Task> list;
  Duration maxTime;
  Duration timeUsed;
  int id;

  // colors - assigned color will be overriden if user sets task colors individually
  Color newItemColor =
      Color.fromRGBO(57, 161, 135, 1); // the color used for the "new item" card
  Color defaultColor =
      Color.fromRGBO(150, 0, 0, 1); // the color used by default for cards
  List<Color> colors400 = [
    Color.fromRGBO(227, 134, 106, 1),
    Color.fromRGBO(188, 103, 134, 1),
    Color.fromRGBO(238, 93, 93, 1), //Don't know why but it starts here
    Color.fromRGBO(111, 89, 171, 1),
    Color.fromRGBO(51, 130, 209, 1),
    Color.fromRGBO(50, 196, 196, 1),
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

  // returns a task at the value index provided
  Task getTaskAt(int index) {
    if (index < list.length) return list.values.elementAt(index);
    return null;
  }

  bool isTimeValid(Duration t) => (timeUsed + t <= maxTime);

  Color getDefaultColor() {
    int count = this.getLength();
    int maxCount = colors400.length;

    for (int i = 0; i <= count; i++) {
      if (i == count) {
        return colors400[i % maxCount];
      }
    }
    return null;
  }
}
