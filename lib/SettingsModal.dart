import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModal extends StatefulWidget {
  @override
  _SettingsModalState createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {

  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _isDarkMode;
  Future<bool> _shouldDelete;

  toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.setBool("isDarkMode", value).then((bool success) {
        return value;
      });
    });
  }

  toggleDelete(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _shouldDelete = prefs.setBool("shouldDelete", value).then((bool success) {
        return value;
      });
    });
  }
  
  @override
  void initState() {
    super.initState();
    _isDarkMode = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool("isDarkMode") ?? true;
    });
    _shouldDelete = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool("shouldDelete") ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Settings"),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // toggle dark mode
            FutureBuilder<bool>(
              future: _isDarkMode,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile();
                } else {
                  if (snapshot.hasError) {
                    return ListTile(title: Text("Error: ${snapshot.error}"));
                  } else {
                    return SwitchListTile(
                      value: snapshot.data,
                      title: Text("Dark Mode"),
                      activeColor: Colors.red,
                      contentPadding: EdgeInsets.all(0),
                      onChanged: (value) {
                        toggleDarkMode(value);
                      },
                    );
                  }
                }
              },
            ),
            // toggle should delete tasks after 30 days
            FutureBuilder<bool>(
              future: _shouldDelete,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile();
                } else {
                  if (snapshot.hasError) {
                    return ListTile(title: Text("Error: ${snapshot.error}"));
                  } else {
                    return SwitchListTile(
                      value: snapshot.data,
                      title: Text("Delete tasks after 30 days"),
                      activeColor: Colors.red,
                      contentPadding: EdgeInsets.all(0),
                      onChanged: (value) {
                        toggleDelete(value);
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      )
    );
  }
}