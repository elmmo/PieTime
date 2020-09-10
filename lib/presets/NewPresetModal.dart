import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../tasks/TaskList.dart';

class NewPresetModal extends StatelessWidget {
  NewPresetModal({Key key, @required this.taskList}) : super(key: key);

  final TaskList taskList;
  final titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        width: double.maxFinite,
        child: Form(
          key: formKey,
          child: Container(
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
                  return "Preset title can't be empty";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration.collapsed(
                hintText: "Preset name",
                hintStyle: TextStyle(color: Color.fromRGBO(182, 182, 182, 0.7), fontSize: 16)
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text("Save"),
          onPressed: () async {
            if (formKey.currentState.validate()) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              List<String> presets = prefs.getStringList("presets");
              if (presets == null) {
                presets = [];
              }
              List<Map<String, dynamic>> thisPreset = [];
              taskList.orderedTasks.forEach((task) {
                thisPreset.add({
                  "title" : task.title,
                  "time" : task.time
                });
              });
              Map<String, dynamic> presetWithName = {
                "name" : titleController.text,
                "tasks" : thisPreset
              };
              String jsonString = json.encode(presetWithName, toEncodable: (e) => e.toString());
              presets.add(jsonString);
              prefs.setStringList("presets", presets);
              Navigator.pop(context);
            }
          }
        )
      ],
    );
  }
}