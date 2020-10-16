import 'package:flutter/material.dart';
import 'Task.dart';
import '../util/Theme.dart';

int colorValue = 300; //Increment by 100 to change shade
List<Color> sliceColors = [
  //Colors for task slices
  CustomColor.red[colorValue],
  CustomColor.purple[colorValue],
  CustomColor.blue[colorValue],
  CustomColor.green[colorValue],
  CustomColor.orange[colorValue],
  CustomColor.pink[colorValue],
];

class TaskList {
  List<Task> orderedTasks; // Keeps track of the order of items in list
  Duration maxTime;
  Duration timeUsed;

  TaskList() {
    this.orderedTasks = new List();
    this.maxTime = Duration.zero;
    this.timeUsed = Duration.zero;
  }

    int getLength() => orderedTasks.length;

  void setMaxTime(Duration time) {
    maxTime = time;
  }

  Task getTaskAt(int index) {
    if (index < getLength()) {
      return orderedTasks.elementAt(index);
    } else {
      return null;
    }
  }

  Task addTask(Task task) {
    orderedTasks.add(task);
    task.update(true, newColor: getDefaultColor());
    return task;
  }

  Task updateTask(Task task,
      {int changeIndex,
      String title,
      Duration newTime,
      bool isComplete,
      Color newColor}) {
    if (task == null) return null;
    if (newColor != null) {
      task.update(true, newColor: newColor);
    }
    if (newTime != null) {
      task.update(true, newTime: newTime);
    }
    if (title != null) {
      task.update(true, newTitle: title);
    }
    if (isComplete != null) {
      task.update(true, isComplete: isComplete);
    }
    if (task.isNew) {
      task.isNew = false;
    }
    if (changeIndex != null) {
      removeAt(changeIndex);
      insert(changeIndex, task);
    }
    return task;
  }

  Task getLast() {
    return orderedTasks.elementAt(getLength() - 1);
  }

  void insert(int index, Task value) {
    orderedTasks.insert(index, value);
  }

  void removeAt(int index) {
    orderedTasks.removeAt(index);
  }

  void remove(Task task) {
    orderedTasks.remove(task);
  }

  void clear() {
    orderedTasks.clear();
  }

  Color getDefaultColor() {
    int count = orderedTasks.length - 1;
    int maxCount = sliceColors.length;

    for (int i = 0; i <= count; i++) {
      if (i == count) {
        return sliceColors[i % maxCount];
      }
    }
    return null;
  }

  @override
  String toString() {
    String result = "TaskList ";
    if (getLength() == 0) {
      result += "(empty)";
    } else {
      for (int i = 0; i < getLength(); i++) {
        result += getTaskAt(i).toString();
        result += " ";
      }
    }
    return result;
  }
}
