import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'theme.dart';

class SettingsModal extends StatefulWidget {
  @override
  _SettingsModalState createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();
  Future<bool> _isDarkMode;
  Future<bool> _shouldDelete;
  Future<bool> _isAwake;

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

  toggleAwake(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAwake = prefs.setBool("isAwake", value).then((bool success) {
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
    _isAwake = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool("isAwake") ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Settings",
            style:
                Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 25)),
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
                        title: Text("Dark Mode",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 15)),
                        activeColor: Theme.of(context).primaryColorLight,
                        contentPadding: EdgeInsets.all(0),
                        onChanged: (value) {
                          toggleDarkMode(value);
                          value
                              ? _changeTheme(context, MyThemeKeys.DARK)
                              : _changeTheme(context, MyThemeKeys.LIGHT);
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
                        title: Text("Delete tasks after 30 days",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 15)),
                        activeColor: Theme.of(context).primaryColorLight,
                        contentPadding: EdgeInsets.all(0),
                        onChanged: (value) {
                          toggleDelete(value);
                        },
                      );
                    }
                  }
                },
              ),
              // toggle wakelock
              FutureBuilder<bool>(
                future: _isAwake,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile();
                  } else {
                    if (snapshot.hasError) {
                      return ListTile(title: Text("Error: ${snapshot.error}"));
                    } else {
                      return SwitchListTile(
                        value: snapshot.data,
                        title: Text("Keep screen on",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 15)),
                        activeColor: Theme.of(context).primaryColorLight,
                        contentPadding: EdgeInsets.all(0),
                        onChanged: (value) {
                          toggleAwake(value);
                          value ? Wakelock.enable() : Wakelock.disable();
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