import 'package:flutter/material.dart';

class BottomDrawer extends StatefulWidget {
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

  static String _title = "title";
  static String _time = "time";
  static String _completed = "completed";
  static String _new = "new";
  // the first three are just test data, but the fourth item needs to stay
  List<Map<String, dynamic>> items = [
    {
      _title : "Mobile Apps Mockings",
      _time : Duration(minutes: 15),
      _completed : false,
      _new : false,
    },
    {
      _title : "Graphic Design Sketch",
      _time : Duration(minutes: 15),
      _completed : false,
      _new : false,
    },
    {
      _title : "Core 250 RR",
      _time : Duration(minutes: 10),
      _completed : false,
      _new : false,
    },
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
        items.insert(0, newItem);
        numNew++;
      } else {
        int index = items.indexWhere((e) => e[_title] == oldItem[_title] && e[_time] == oldItem[_time] && e[_completed] == oldItem[_completed] && e[_new] == oldItem[_new]);
        items[index] = newItem;
      }
    });
  }

  toggleCompleted(int index) {
    setState(() {
      items[index][_completed] = !items[index][_completed];
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
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    String title = items[index][_title];
                    Duration time = items[index][_time];
                    bool isCompleted = items[index][_completed];
                    bool isNew = items[index][_new];

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
                                      return ItemModal(color: colors[(index-items.length-numNew) % colors.length], onPressed: updateItem, isCompleted: isCompleted);
                                    }
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ItemModal(color: colors[(index-numNew) % colors.length], onPressed: updateItem, oldTitle: title, oldTime: time, isCompleted: isCompleted);
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
    @required this.color,
    @required this.onPressed(bool isCreation, String newTitle, Duration newTime, String oldTitle, Duration oldTime, bool isCompleted),
    this.oldTitle = "",
    this.oldTime = const Duration(minutes: -1),
    this.isCompleted = false
  }) : super(key: key);

  final Color color;
  final Function onPressed;
  final String oldTitle;
  final Duration oldTime;
  final bool isCompleted;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final durationController = TextEditingController();

  // Returns the number of minutes from a Duration of hours and minutes
  String parseDuration(Duration time) {
    String timeStr = time.toString();
    int colonPos = timeStr.indexOf(":");
    int hours = int.parse(timeStr.substring(0, colonPos));
    int minutes = int.parse(timeStr.substring(colonPos+1, colonPos+3));
    return (minutes + hours*60).toString();
  }

  @override
  Widget build(BuildContext context) {
    bool isCreation = oldTitle == "" || oldTime == Duration(minutes: -1);
    if (!isCreation) {
      titleController.text = oldTitle;
      durationController.text = parseDuration(oldTime);
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
                  if (value.isEmpty) {
                    return "Item title can't be empty";
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
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color.fromRGBO(182, 182, 182, 1)))
              ),
              child: TextFormField(
                controller: durationController,
                maxLength: 3, // max number of characters for time - max 999min
                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                textInputAction: TextInputAction.done,
                style: TextStyle(color: Color.fromRGBO(182, 182, 182, 1), fontSize: 16),
                validator: (value) {
                  if (int.tryParse(value) == null) {
                    return "Duration must be a number";
                  }
                  return null;
                },
                decoration: InputDecoration.collapsed(
                  hintText: "Duration in minutes",
                  hintStyle: TextStyle(color: Color.fromRGBO(182, 182, 182, 0.7), fontSize: 16)
                ),
              ),
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
                    onPressed(true, titleController.text, Duration(minutes: int.parse(durationController.text)), oldTitle, oldTime, isCompleted);
                  } else {
                    onPressed(false, titleController.text, Duration(minutes: int.parse(durationController.text)), oldTitle, oldTime, isCompleted);
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
