import 'package:flutter/material.dart';

class ItemModal extends StatelessWidget {
  ItemModal({
    Key key,
    @required this.totalDuration,
    @required this.taskDuration,
    @required this.color,
    @required this.onUpdate(bool isCreation, String newTitle, Duration newTime, String oldTitle, Duration oldTime, bool isCompleted),
    @required this.onDelete(String title, Duration time, bool isCompleted),
    this.oldTitle = "",
    this.oldTime = const Duration(minutes: -1),
    this.isCompleted = false
  }) : super(key: key);

  final Duration totalDuration;
  final Duration taskDuration;
  final Color color;
  final Function onUpdate;
  final Function onDelete;
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

            Row(
              mainAxisAlignment: !isCreation ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
              children: <Widget>[
                // Delete button if not creating a new task
                !isCreation ? RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)), side: BorderSide(color: Color.fromRGBO(209, 26, 42, 1))),
                  color: Color.fromRGBO(80, 80, 80, 1),
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Color.fromRGBO(209, 26, 42, 1), fontSize: 16),
                  ),
                  onPressed: () {
                    onDelete(
                      titleController.text,
                      Duration(
                        hours: hoursController.text.isNotEmpty ? int.parse(hoursController.text) : 0,
                        minutes: minutesController.text.isNotEmpty ? int.parse(minutesController.text) : 0,
                        seconds: secondsController.text.isNotEmpty ? int.parse(secondsController.text) : 0
                      ),
                      isCompleted
                    );
                    Navigator.pop(context);
                  },
                ) : Container(),

                // Action button
                RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  color: color, // button color will be the same color as the item's color, if it's a new item the color is the color it will be once created
                  child: Text(
                    isCreation ? "Create" : "Update",
                    style: TextStyle(color: Colors.black, fontSize: 16)
                  ),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      // if there's not an old title or time, we're creating a new item
                      if (isCreation) {
                        onUpdate(
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
                        onUpdate(
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
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}
