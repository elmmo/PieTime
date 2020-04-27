import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'OrgComponents.dart';

void main() => runApp(new PieTimerApp());

// entry for the rest of the app 
class PieTimerApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pie Timer",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColorDark: Colors.white,
        accentColor: Colors.red,
        backgroundColor: Colors.grey[800],
        secondaryHeaderColor: Colors.grey[900],
        textTheme: GoogleFonts.almaraiTextTheme(
          Theme.of(context).textTheme
        ),
      ),
      home: Home(),
    );
  }
}

// This is pulled out in order to allow the settings modal to be shown from the AppBar
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: OrgComponents.generateSideDrawer(),
      appBar: OrgComponents.generateAppBar(context),
      // Contains everything below the Appbar
      backgroundColor: Colors.grey[800],
      body: OrgComponents.generateAppBody(Theme.of(context)), 
    );
  }
}