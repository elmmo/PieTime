import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'OrgComponents.dart';
import 'timer_face/SetTime.dart';

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
      home: Scaffold(
        appBar: OrgComponents.generateAppBar(), 
        drawer: OrgComponents.generateSideDrawer(), 
        body: SetTime()
      )
      
      
      // Scaffold(
      //   drawer: OrgComponents.generateSideDrawer(),
      //   appBar: OrgComponents.generateAppBar(),
      //   // Contains everything below the Appbar
      //   backgroundColor: Colors.grey[800],
      //   body: OrgComponents.generateAppBody(Theme.of(context)), 
      // ),
    );
  }
}