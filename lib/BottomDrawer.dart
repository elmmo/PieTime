import 'package:flutter/material.dart';

class BottomDrawer extends StatefulWidget {

  final Duration totalDuration;

  BottomDrawer(int hrs, int min, int sec)
    : totalDuration = Duration(hours: hrs, minutes: min, seconds: sec);

  @override
  _BottomDrawerState createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {

  // we probably need more colors
  List<Color> colors = [
    Color.fromRGBO(173, 79, 79, 1),
    Color.fromRGBO(47, 128, 139, 1),
    Color.fromRGBO(98, 86, 132, 1),
  ];
  // green color for the "new item" card
  Color newColor = Color.fromRGBO(57, 161, 135, 1);

  Duration taskDuration = Duration.zero;

  static String _title = "title";
  static String _time = "time";
  static String _completed = "completed";
  static String _new = "new";
  // This item is the card for creating a new task
  List<Map<String, dynamic>> tasks = [
    {
      _title : "New Task",
      _time : null,
      _completed : false,
      _new : true,
    },
  ];

  int numNew = 0;
  updateItem(bool isCreation, String newTitle, Duration newTime, String oldTitle, Duration oldTime, bool isCompleted) {
    Map<String, dynamic> oldItem = {
      _title : oldTitle,
      _time : oldTime,
      _completed : isCompleted,
      _new : false
    };
    Map<String, dynamic> newItem = {
      _title : newTitle,
      _time : newTime,
      _completed : isCompleted,
      _new : false
    };
    setState(() {
      // create new item or update info of existing item
      if (isCreation) {
        tasks.insert(0, newItem);
        numNew++;
      } else {
        int index = tasks.indexWhere((e) => e[_title] == oldItem[_title] && e[_time] == oldItem[_time] && e[_completed] == oldItem[_completed] && e[_new] == oldItem[_new]);
        tasks[index] = newItem;
      }
      taskDuration += newItem[_time];
    });
  }

  toggleCompleted(int index) {
    setState(() {
      tasks[index][_completed] = !tasks[index][_completed];
    });
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
                  color: Color.fromRGBO(51, 51, 51, 1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                child: Container(
                  child: Icon(
                    Icons.drag_handle,
                    size: 32,
                    color: Color.fromRGBO(121, 121, 121, 1)
                  ),
                ),
              ),

              // holds the list of items
              Container(
                height: (MediaQuery.of(context).size.height * 0.5) - 64,
                width: MediaQuery.of(context).size.width,
                color: Color.fromRGBO(51, 51, 51, 1),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: 16
                  ),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    String title = tasks[index][_title];
                    Duration time = tasks[index][_time];
                    bool isCompleted = tasks[index][_completed];
                    bool isNew = tasks[index][_new];

                    return Card(
                      color: Color.fromRGBO(80, 80, 80, 1),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // colored left border workaround
                          Container(
                            width: 4,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isNew ? newColor : colors[(index-numNew) % colors.length],
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              dense: true,
                              leading: isNew // left icon, if it's the "new item" card it has a different icon than the others
                              ? Icon(
                                  Icons.add_circle,
                                  size: 24,
                                  color: newColor
                                )
                              : IconButton(
                                  icon: Icon(
                                    isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                                    size: 24,
                                    color: colors[(index-numNew) % colors.length]
                                  ),
                                  onPressed: () {
                                    toggleCompleted(index);
                                  },
                                ),
                              title: Text(
                                title,
                                style: TextStyle(color: Color.fromRGBO(182, 182, 182, 1), fontSize: 12)
                              ),

                              // right icon, "new item" card doesn't have one
                              trailing: Icon(
                                isNew ? null : Icons.more_horiz,
                                size: 32,
                                color: isNew ? newColor : Color.fromRGBO(136, 136, 136, 1)
                              ),
                              onTap: () {
                                // Same modal is shown with slight tweaks based on whether the tapped card is the "new item" card or not
                                if (isNew) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ItemModal(
                                        totalDuration: widget.totalDuration,
                                        taskDuration: taskDuration,
                                        color: colors[(index-tasks.length-numNew) % colors.length],
                                        onPressed: updateItem,
                                        isCompleted: isCompleted
                                      );
                                    }
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ItemModal(
                                        totalDuration: widget.totalDuration,
                                        taskDuration: taskDuration,
                                        color: colors[(index-numNew) % colors.length],
                                        onPressed: updateItem,
                                        oldTitle: title,
                                        oldTime: time,
                                        isCompleted: isCompleted
                                      );
                                    }
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      )
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
}


class ItemModal extends StatelessWidget {
  ItemModal({
    Key key,
    @required this.totalDuration,
    @required this.taskDuration,
    @required this.color,
    @required this.onPressed(bool isCreation, String newTitle, Duration newTime, String oldTitle, Duration oldTime, bool isCompleted),
    this.oldTitle = "",
    this.oldTime = const Duration(minutes: -1),
    this.isCompleted = false
  }) : super(key: key);

  final Duration totalDuration;
  final Duration taskDuration;
  final Color color;
  final Function onPressed;
  final String oldTitle;
  final Duration oldTime;
  final bool isCompleted;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final hoursController = TextEditingController();
  final minutesController = TextEditingController();
  final secondsController = TextEditingController();

  // Returns the number of hours from a Duration of hours and minutes
  String parseHours(Duration time) {
    String timeStr = time.toString();
    int colonPos = timeStr.indexOf(":");
    int hours = int.parse(timeStr.substring(0, colonPos));
    // int minutes = int.parse(timeStr.substring(colonPos+1, colonPos+3));
    return hours.toString();
  }

  // Returns the number of minutes from a Duration of hours and minutes
  String parseMinutes(Duration time) {
    String timeStr = time.toString();
    int colonPos = timeStr.indexOf(":");
    // int hours = int.parse(timeStr.substring(0, colonPos));
    int minutes = int.parse(timeStr.substring(colonPos+1, colonPos+3));
    return minutes.toString();
  }

  // Returns the number of seconds from a Duration of hours and minutes
  String parseSeconds(Duration time) {
    String timeStr = time.toString();
    int colonPos = timeStr.indexOf(":");
    // int hours = int.parse(timeStr.substring(0, colonPos));
    // int minutes = int.parse(timeStr.substring(colonPos+1, colonPos+3));
    int seconds = int.parse(timeStr.substring(colonPos+4, colonPos+6));
    return seconds.toString();
  }

  @override
  Widget build(BuildContext context) {
    bool isCreation = oldTitle == "" || oldTime == Duration(minutes: -1);
    if (!isCreation) {
      titleController.text = oldTitle;
      hoursController.text = parseHours(oldTime);
      minutesController.text = parseMinutes(oldTime);
      secondsController.text = parseSeconds(oldTime);
    }
    return AlertDialog(
      backgroundColor: Color.fromRGBO(80, 80, 80, 1),
      title: Text(
        isCreation ? "New Item" : oldTitle,
        style: TextStyle(color: Color.fromRGBO(182, 182, 182, 1), fontSize: 24)
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // item title text box
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color.fromRGBO(182, 182, 182, 1)))
              ),
              child: TextFormField(
                controller: titleController,
                maxLength: 50, // max number of characters for item title
                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                textInputAction: TextInputAction.done,
                style: TextStyle(color: Color.fromRGBO(182, 182, 182, 1), fontSize: 16),
                validator: (value) {
                  String hrs = hoursController.text;
                  String min = minutesController.text;
                  String sec = secondsController.text;
                  bool hrsIsEmpty = hrs.isEmpty;
                  bool minIsEmpty = min.isEmpty;
                  bool secIsEmpty = sec.isEmpty;
                  bool hrsIsInt = int.tryParse(hrs) == null;
                  bool minIsInt = int.tryParse(min) == null;
                  bool secIsInt = int.tryParse(sec) == null;
                  int hrsInt = !hrsIsEmpty ? int.parse(hrs) : 0;
                  int minInt = !minIsEmpty ? int.parse(min) : 0;
                  int secInt = !secIsEmpty ? int.parse(sec) : 0;
                  Duration proposedDuration = Duration(hours: hrsInt, minutes: minInt, seconds: secInt);

                  if (value.isEmpty) {
                    return "Item title can't be empty";
                  } else if (hrsIsEmpty && minIsEmpty && secIsEmpty) {
                    return "Duration can't be empty";
                  } else if ((!hrsIsEmpty && hrsIsInt) || (!minIsEmpty && minIsInt) || (!secIsEmpty && secIsInt)) {
                    return "Duration must be a number";
                  } else if (hrs == "0" && min == "0" && sec == "0") {
                    return "Duration can't be zero";
                  } else if ((taskDuration + proposedDuration) > totalDuration) {
                    return "Total timer duration exceeded";
                  }
                  return null;
                },
                decoration: InputDecoration.collapsed(
                  hintText: "Item title",
                  hintStyle: TextStyle(color: Color.fromRGBO(182, 182, 182, 0.7), fontSize: 16)
                ),
              ),
            ),

            // duration text box
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color.fromRGBO(182, 182, 182, 1)))
                    ),
                    child: TextFormField(
                      controller: hoursController,
                      maxLength: 2, // max number of characters for time - max 99hr
                      buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(color: Color.fromRGBO(182, 182, 182, 1), fontSize: 16),
                      decoration: InputDecoration.collapsed(
                        hintText: "0"
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text("hr", style: TextStyle(color: Color.fromRGBO(182, 182, 182, 1), fontSize: 16)),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color.fromRGBO(182, 182, 182, 1)))
                    ),
                    child: TextFormField(
                      controller: minutesController,
                      maxLength: 3, // max number of characters for time - max 1hr 33min
                      buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(color: Color.fromRGBO(182, 182, 182, 1), fontSize: 16),
                      decoration: InputDecoration.collapsed(
                        hintText: "0"
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text("min", style: TextStyle(color: Color.fromRGBO(182, 182, 182, 1), fontSize: 16)),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color.fromRGBO(182, 182, 182, 1)))
                    ),
                    child: TextFormField(
                      controller: secondsController,
                      maxLength: 3, // max number of characters for time - max 1min 33s
                      buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(color: Color.fromRGBO(182, 182, 182, 1), fontSize: 16),
                      decoration: InputDecoration.collapsed(
                        hintText: "0"
                      ),
                    ),
                  ),
                ),
                Text("s", style: TextStyle(color: Color.fromRGBO(182, 182, 182, 1), fontSize: 16)),
              ],
            ),
            Container(height: 8, width: 0),

            // action button
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              color: color, // button color will be the same color as the item's color, if it's a new item the color is the color it will be once created
              child: Text(
                oldTitle == "" || oldTime == Duration(minutes: -1) ? "Create" : "update",
                style: TextStyle(color: Colors.black, fontSize: 16)
              ),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  // if there's not an old title or time, we're creating a new item
                  if (oldTitle == "" || oldTime == Duration(minutes: -1)) {
                    onPressed(
                      true,
                      titleController.text,
                      Duration(
                        hours: hoursController.text.isNotEmpty ? int.parse(hoursController.text) : 0,
                        minutes: minutesController.text.isNotEmpty ? int.parse(minutesController.text) : 0,
                        seconds: secondsController.text.isNotEmpty ? int.parse(secondsController.text) : 0
                      ),
                      oldTitle,
                      oldTime,
                      isCompleted
                    );
                  } else {
                    onPressed(
                      false,
                      titleController.text,
                      Duration(
                        hours: hoursController.text.isNotEmpty ? int.parse(hoursController.text) : 0,
                        minutes: minutesController.text.isNotEmpty ? int.parse(minutesController.text) : 0,
                        seconds: secondsController.text.isNotEmpty ? int.parse(secondsController.text) : 0
                      ),
                      oldTitle,
                      oldTime,
                      isCompleted
                    );
                  }
                  Navigator.pop(context);
                }
              },
            )
          ],
        )
      ),
    );
  }
}
