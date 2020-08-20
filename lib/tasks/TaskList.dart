import 'package:flutter/material.dart';
import 'Task.dart';
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

class TaskList {
  List<Task> orderedTasks; // Keeps track of the order of items in list
  Duration maxTime;
  Duration timeUsed;

  TaskList({Duration maxTime}) {
    this.orderedTasks = new List();
    this.maxTime = (maxTime == null) ? Duration.zero : maxTime;  
    this.timeUsed = Duration.zero;
  }

  int getLength() => orderedTasks.length;

  void setMaxTime(Duration time) {
    maxTime = time;
  }

  Task getTaskAt(int index) {
    return orderedTasks.elementAt(index); 
  }

  bool addTask(String title, {Duration time}) {
    Task newestTask = new Task(orderedTasks.length);
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

  bool updateTask(Task task, 
      {String title,
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
    if (task.isNew) {
      task.isNew = false; 
    }
    return true;
  }

  void removeByIndex(int index) {
    timeUsed -= orderedTasks[index].time;
    orderedTasks.removeAt(index);
  }

  void remove(Task task) {
    timeUsed -= task.time; 
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

  bool isTimeValid(Duration t) => (timeUsed + t <= maxTime);

  Duration getTimeRemaining() {
    return maxTime - timeUsed; 
  }
}
