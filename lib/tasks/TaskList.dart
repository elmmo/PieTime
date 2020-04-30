import 'package:flutter/material.dart';
import 'Task.dart';

class TaskList {
  Map<int, Task> list; 
  Duration maxTime; 
  Duration timeUsed;
  int id; 

  // colors - assigned color will be overriden if user sets task colors individually
  Color newItemColor; // the color used for the "new item" card
  Color defaultColor; // the color used by default for cards 

  TaskList() {
    maxTime = Duration.zero; 
    list = new Map<int, Task>(); 
    timeUsed = Duration.zero; 
    id = 0;  // for assigning id to tasks
  }

  int getLength() => list.length; 

  void setMaxTime(Duration time) {
    maxTime = time; 
  }

  void createAddButton() {
    list[id] = new Task(id, null);
    list[id].update(true, newColor: newItemColor);
    id++; 
  }
  
  // adds task and returns whether it succeeded or not 
  bool addTask(String title, {Duration time}) {
    Task newestTask = list[list.length-1]; 
    // remove status as the "new item" card
    newestTask.isNew = false;
    newestTask.update(true, newColor: defaultColor);
    // set task specifications 
    newestTask.update(true, newTitle: title);
    if (time == null) {
      return true; 
    } else if (isTimeValid(time)) {
      list[list.length-1].update(true, newTime: time);
      timeUsed += time; 
      return true; 
    }
    return false; 
  }

  // updates a given task based on its id after checking time (if time set)
  bool updateTask(id, {Task t, String title, Duration time, bool isComplete, Color newColor}) {
    if (time != null) {
      if (isTimeValid(time)) {
        list[list.length-1].update(true, newTime: time);
      } else {
        // if requested duration is greater than the set time 
        return false; 
      }
    }
    if (title != null) {
      list[list.length-1].update(true, newTitle: title); 
    }
    if (isComplete != null) {
      list[list.length-1].update(true, isComplete: isComplete);
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

  bool isTimeValid(Duration t) {
    return timeUsed + t <= maxTime; 
  }
}
