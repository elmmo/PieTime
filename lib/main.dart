import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'OrgComponents.dart';
import 'theme.dart';

void main() => runApp(CustomTheme(
      initialThemeKey: MyThemeKeys.DARK,
      child: PieTimerApp(),
    ));

// entry for the rest of the app
class PieTimerApp extends StatelessWidget {
  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pie Timer",
      theme: CustomTheme.of(context),
      home: Scaffold(
        appBar: OrgComponents.generateAppBar(Theme.of(context)),
        // Contains everything below the Appbar
        body: OrgComponents.generateAppBody(Theme.of(context)),
        // App drawer, moved from OrgComponents.dart 
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Drawer Header',
                ),
                decoration: BoxDecoration(
                  color: CustomTheme.of(context).accentColor,
                ),
              ),
              ListTile(
                title: Text('Light Theme'),
                onTap: () {
                  _changeTheme(context, MyThemeKeys.LIGHT);
                },
              ),
              ListTile(
                title: Text('Dark Theme'),
                onTap: () {
                  _changeTheme(context, MyThemeKeys.DARK);
                },
              ),
              ListTile(
                title: Text('Darker Theme'),
                onTap: () {
                  _changeTheme(context, MyThemeKeys.DARKER);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
