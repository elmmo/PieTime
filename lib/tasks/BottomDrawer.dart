import 'package:flutter/material.dart';
import 'Task.dart';
import 'TaskList.dart';
import 'ItemModal.dart';
import '../TimeKeeper.dart';

class BottomDrawer extends StatefulWidget {

  @override
  _BottomDrawerState createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  TaskList list; 

  Color backgroundColor = Color.fromRGBO(51, 51, 51, 1);
  Color dragTabIconColor = Color.fromRGBO(121, 121, 121, 1);
  Color cardBackgroundColor = Color.fromRGBO(80, 80, 80, 1);
  Color cardTextColor = Color.fromRGBO(182, 182, 182, 1); 
  // green color for the "new item" card
  Color newColor = Color.fromRGBO(57, 161, 135, 1);

  void initState() {
    list = new TaskList(); 
    list.createAddButton();
    list.maxTime = Duration.zero; 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (TimeKeeper.of(context) != null) {
      final time = TimeKeeper.of(context).time;
      list.maxTime = time; 
    }
    // this is the component that allows dragging up and down
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        // scroll view for items in the drawer
        return SingleChildScrollView(
          physics: ClampingScrollPhysics(), // supposed to stop from ever scrolling past bounds
          controller: scrollController,
          child: Column(
            children: <Widget>[
              // drag tab
              Container(
                height: 24,
                width: 64,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                // drag tab icon 
                child: Container(
                  child: Icon(
                    Icons.drag_handle,
                    size: 32,
                    color: dragTabIconColor, 
                  ),
                ),
              ),

              // holds the list of items 
              Container(
                height: (MediaQuery.of(context).size.height * 0.5) - 64,
                width: MediaQuery.of(context).size.width,
                color: backgroundColor, 
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: 16
                  ),
                  itemCount: (list.getLength() > 1 ? list.getLength()+1 : list.getLength()),
                  itemBuilder: (context, index) {
                    Task task = list.getTaskAt(index);
                    return (index < list.getLength() ? createCard(task) : createButtonCard());
                  },
                separatorBuilder: (context, index) {
                  return Container(height: 4, width: 0);
                },
                ),
              ),           
            ]
          )
        );
      }
    );
  }

  // left tab border 
  Widget getCardBorder(Task task) {
    return Container(
      width: 4,
      height: 48,
      decoration: BoxDecoration(
        color: task.color,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
      ),
    );
  }

  // creates the main section of the card
  Widget getCardBody(Task task) {
    return Expanded(
      child: ListTile(
        dense: true,
        leading: task.isNew
        // add icon for the "new item" card 
        ? Icon(Icons.add_circle, size: 24, color: newColor)
        // icon for completed/uncompleted status 
        : IconButton(
            icon: Icon(
              task.completed ? Icons.check_box : Icons.check_box_outline_blank,
              size: 24,
              color: task.color
            ),
            onPressed: () {
              return updateCard(task: task, isComplete: (task.completed ? false : true));
            }
          ),
        title: Text(task.title, style: TextStyle(color: cardTextColor, fontSize: 12)),
      )
    );
  }

  void updateCard({Task task, bool isComplete, Duration newTime, String newTitle}) {
    if (list.getTaskAt(list.getLength()-1) == task) {
      list.createAddButton();
    }
    setState(() {
      list.updateTask(task: task, title: newTitle, newTime: newTime, isComplete: isComplete); 
    });
  }

  void deleteCard(Task task) {
    setState(() {
      list.deleteTask(task); 
    });
  }

  Widget createCard(Task task) {
    return GestureDetector(
      child: Card(
        color: cardBackgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getCardBorder(task),
            getCardBody(task),
          ],
        )
      ),
      onTap: () {
        showDialog(
          context: context, 
          builder: (context) {
            return ItemModal(
              task: task,
              totalDuration: list.maxTime,
              taskDuration: task.time,  
              timeChecker: list.isTimeValid,
              color: (task.isNew ? list.newItemColor : list.defaultColor),
              onUpdate: updateCard,
              onDelete: deleteCard,
            );
          }
        );
      }
    );
  }

  Widget createButtonCard() {
    return Container(
      color: backgroundColor,
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly, 
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                list.deleteAllTasks();
              });
            }
          )
        ]
      )
    );
  }

}