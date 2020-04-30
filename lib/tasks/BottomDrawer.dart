import 'package:flutter/material.dart';
import 'Task.dart';
import 'TaskList.dart';
// import 'ItemModal.dart';

class BottomDrawer extends StatefulWidget {

  final Duration totalDuration;

  BottomDrawer(this.totalDuration); 

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  itemCount: list.getLength(),
                  itemBuilder: (context, index) {
                    Task task = list.getTaskAt(index);
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
                        // Same modal is shown with slight tweaks based on whether the tapped card is the "new item" card or not
                        if (task.isNew) {
                          showDialog(
                            context: context,
                              builder: (context) {
                                return ItemModal(
                                  totalDuration: list.maxTime,
                                  taskDuration: task.time, 
                                  color: newColor, 
                                  onUpdate: task.update,
                                  onDelete: list.deleteTask,
                                  isCompleted: task.completed,
                                );
                              }
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ItemModal(
                                totalDuration: list.maxTime, 
                                taskDuration: task.time, 
                                color: list.defaultColor,
                                onUpdate: task.update, 
                                onDelete: list.deleteTask,
                                oldTitle: task.title,
                                oldTime: task.time, 
                                isCompleted: task.completed
                              );
                            }
                          );
                        }
                      }
                    );
                  },
                separatorBuilder: (context, index) {
                  return Container(height: 4, width: 0);
                },
                )
              )
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
            onPressed: () => task.update(false, isComplete: true)
          ),
        title: Text(task.title, style: TextStyle(color: cardTextColor, fontSize: 12)),
      )
    );
  }

}