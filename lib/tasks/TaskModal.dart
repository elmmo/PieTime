import 'package:flutter/material.dart';
import 'Task.dart';
import '../util/Theme.dart';


// the popup dialog that comes up for creating or updating tasks
class TaskModal extends StatelessWidget {
  TaskModal({
    Key key,
    @required this.totalDuration,
    @required this.taskDuration,
    @required this.color,
    @required this.timeChecker,
    @required this.onUpdate,
    @required this.onDelete,
    @required this.task,
  }) : super(key: key);

  final Duration totalDuration;
  final Duration taskDuration;
  final Color color;
  final Function timeChecker;
  final Function onUpdate;
  final Function onDelete;
  final Task task;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController(text: "New Task");
  final hoursController = TextEditingController();
  final minutesController = TextEditingController();
  final secondsController = TextEditingController();
  final titleFocus = FocusNode(); // Focus goes to next form field automatically
  final hoursFocus = FocusNode(); // When "Done" is pressed, used by CardField class
  final minutesFocus = FocusNode();
  final secondsFocus = FocusNode();
  final submitFocus = FocusNode();

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
    int minutes = int.parse(timeStr.substring(colonPos + 1, colonPos + 3));
    return minutes.toString();
  }

  // Returns the number of seconds from a Duration of hours and minutes
  String parseSeconds(Duration time) {
    String timeStr = time.toString();
    int colonPos = timeStr.indexOf(":");
    // int hours = int.parse(timeStr.substring(0, colonPos));
    // int minutes = int.parse(timeStr.substring(colonPos+1, colonPos+3));
    int seconds = int.parse(timeStr.substring(colonPos + 4, colonPos + 6));
    return seconds.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (!task.isNew) {
      titleController.text = task.title;
      hoursController.text = parseHours(task.time);
      minutesController.text = parseMinutes(task.time);
      secondsController.text = parseSeconds(task.time);
    }
    return AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      content: Container(
        width: double.maxFinite,
        child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // New Task item title field
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          )),
                  child: TextFormField(
                    controller: titleController,
                    onTap: () => titleController.selection = TextSelection(
                        baseOffset: 0, extentOffset: titleController.text.length),

                    maxLength: 50, // max number of characters for item title
                    buildCounter: (BuildContext context,
                            {int currentLength, int maxLength, bool isFocused}) =>
                        null,
                    textInputAction: TextInputAction.done,
                    focusNode: titleFocus,
                    onFieldSubmitted: (term) {
                      titleFocus.unfocus();
                      FocusScope.of(context).requestFocus(hoursFocus);
                    },
                    style: TextStyle(
                        color: Color.fromRGBO(182, 182, 182, 1), fontSize: 21),
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

                      if (value.isEmpty) {
                        // return "Item title can't be empty";
                      } else if (hrsIsEmpty && minIsEmpty && secIsEmpty) {
                        return "Duration can't be empty";
                      } else if ((!hrsIsEmpty && hrsIsInt) ||
                          (!minIsEmpty && minIsInt) ||
                          (!secIsEmpty && secIsInt)) {
                        return "Duration must be a number";
                      } else if (hrs == "0" && min == "0" && sec == "0") {
                        return "Duration can't be zero";
                      } else if (!this.timeChecker(Duration(
                          hours: hrsInt, minutes: minInt, seconds: secInt))) {
                        return "Total timer duration exceeded";
                      }
                      return null;
                    },
                    decoration: new InputDecoration(
                      // border: InputBorder.none,
                      errorStyle: TextStyle (color: Colors.red[300],),
                      hintStyle: TextStyle(
                          // color: Color.fromRGBO(182, 182, 182, 0.7),
                          fontSize: 20),
                    ).copyWith(contentPadding: const EdgeInsets.only(top: 20.0)),
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CardField(
                        controller: hoursController,
                        thisFocus: hoursFocus,
                        nextFocus: minutesFocus,
                        rightMargin: 10,
                        leftMargin: 0,
                        formLabel: "hours"),
                    CardField(
                        controller: minutesController,
                        thisFocus: minutesFocus,
                        nextFocus: secondsFocus,
                        rightMargin: 0,
                        leftMargin: 0,
                        formLabel: "min"),
                    CardField(
                        controller: secondsController,
                        thisFocus: secondsFocus,
                        nextFocus: submitFocus,
                        rightMargin: 0,
                        leftMargin: 10,
                        formLabel: "sec"),
                  ],
                ),
                Container(height: 8, width: 0),

                Row(
                  mainAxisAlignment: !task.isNew
                      ? MainAxisAlignment.spaceAround
                      : MainAxisAlignment.center,
                  children: <Widget>[
                    // Delete button if not creating a new task
                    !task.isNew
                        ? RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                side: BorderSide(
                                    color: Theme.of(context).errorColor
                                    )),
                            color: Theme.of(context).canvasColor,
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontSize: 20),
                            ),
                            onPressed: () {
                              onDelete(task);
                              Navigator.pop(context);
                            },
                          )
                        : Container(),

                    // Action button
                    RaisedButton(
                      focusNode: submitFocus,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      color: Colors.blue[
                          400], // button color will be the same color as the item's color, if it's a new item the color is the color it will be once created
                      child: Text(task.isNew ? "Create" : "Update",
                          style: TextStyle(color: Theme.of(context).canvasColor, fontSize: 16)),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          // if there's not an old title or time, we're creating a new item
                          onUpdate(
                              task: task,
                              newTitle: titleController.text,
                              newTime: Duration(
                                  hours: hoursController.text.isNotEmpty
                                      ? int.parse(hoursController.text)
                                      : 0,
                                  minutes: minutesController.text.isNotEmpty
                                      ? int.parse(minutesController.text)
                                      : 0,
                                  seconds: secondsController.text.isNotEmpty
                                      ? int.parse(secondsController.text)
                                      : 0),
                              isComplete: task.completed);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

// Styled TextFormField for all fields in TaskModal class
class CardField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode thisFocus;
  final FocusNode nextFocus;
  final double rightMargin;
  final double leftMargin;
  final String formLabel;

  CardField({
    @required this.controller,
    @required this.thisFocus,
    @required this.nextFocus,
    @required this.rightMargin,
    @required this.leftMargin,
    @required this.formLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            top: 15, bottom: 15, right: rightMargin, left: leftMargin),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color.fromRGBO(182, 182, 182, 1)))),
        child: TextFormField(
          controller: controller,
          maxLength: 3, // max number of characters for time - max 1hr 33min
          buildCounter: (BuildContext context,
                  {int currentLength, int maxLength, bool isFocused}) =>
              null,
          textInputAction: TextInputAction.done,
          focusNode: thisFocus,
          onFieldSubmitted: (term) {
            thisFocus.unfocus();
            FocusScope.of(context).requestFocus(nextFocus);
          },
          style:
              TextStyle(color: Color.fromRGBO(182, 182, 182, 1), fontSize: 20),
          decoration: InputDecoration.collapsed(hintText: "0").copyWith(
              labelText: formLabel,
              isDense: true,
              contentPadding: const EdgeInsets.only(top: 20.0)),
        ),
      ),
    );
  }
}