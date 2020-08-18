import 'package:flutter/material.dart';
import '../util/theme.dart';

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

class TaskTest {
  final int id;
  String title;
  Duration time;
  double percentage;
  bool completed;
  Color color;

  TaskTest(this.id) {
    this.title = "UNASSIGNED TITLE";
    this.completed = false;
    this.color = Color(0xffff30a0);
  }

  bool update(bool verified,
      {String newTitle,
      Duration newTime,
      double newPercentage,
      bool isComplete,
      Color newColor}) {
    if (newTitle != null) title = newTitle;
    if (newTime != null) {
      time = newTime;
    }
    if (newPercentage != null) percentage = newPercentage;
    if (isComplete != null) completed = isComplete;
    if (newColor != null) color = newColor;
    return true;
  }
}

class TaskListTest {
  // Map<int, Task> list; //idk if we even need this???
  List<TaskTest> orderedTasks; // Keeps track of the order of items in list
  Duration maxTime;
  Duration timeUsed;
  int lastIndex;

  TaskListTest() {
    maxTime = Duration.zero;
    // list = new Map<int, Task>();
    timeUsed = Duration.zero;
    lastIndex = 0; // for assigning id to tasks
    orderedTasks = new List();
  }

  int getLength() => orderedTasks.length;

  void setMaxTime(Duration time) {
    maxTime = time;
  }

  bool addTask(String title, {Duration time}) {
    TaskTest newestTask = new TaskTest(orderedTasks.length);
    newestTask.update(true, newTitle: title, newColor: getDefaultColor());
    orderedTasks.add(newestTask);
    print("TIme: $time");
    print("TOTAL TIme: $maxTime");
    if (time == null) {
      return true;
      // } else if (isTimeValid(time)) {
    } else {
      print("newestTask.title: ${newestTask.title}");
      newestTask.update(true, newTime: time);
      // newestTask.update(true,
      //     newPercentage:
      //         time.inMinutes.toDouble() / maxTime.inMinutes.toDouble());
      timeUsed += time;
      return true;
    }
  }

  bool updateTask(
      {TaskTest task,
      String title,
      Duration newTime,
      bool isComplete,
      Color newColor}) {
    if (task == null) return false;
    if (newColor != null) {
      task.update(true, newColor: newColor);
    }
    if (newTime != null) {
      // if (isTimeValid(newTime)) {
      task.update(true, newTime: newTime);
      // task.update(true,
      //     newPercentage:
      //         newTime.inMinutes.toDouble() / maxTime.inMinutes.toDouble());
      timeUsed += newTime;
      // } else {
      //   // if requested duration is greater than the set time
      //   return false;
      // }
    }
    if (title != null) {
      task.update(true, newTitle: title);
    }
    if (isComplete != null) {
      task.update(true, isComplete: isComplete);
    }
    return true;
  }

  void deleteTaskByIndex(int index) {
    timeUsed -= orderedTasks[index].time;
    orderedTasks.removeAt(index);
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
}
