import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'OrgComponents.dart';
import 'PieTimer.dart';

void main() => runApp(new PieTimerApp());

// entry for the rest of the app 
class PieTimerApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pie Timer",
      theme: ThemeData(
        textTheme: GoogleFonts.almaraiTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: PieTimer(0, 0, 10)  // params are how you set time -- need to provide user way to get that
      
        //     Scaffold(
        //   drawer: OrgComponents.generateSideDrawer(),
        //   appBar: OrgComponents.generateAppBar(),
        //   // Contains everything below the Appbar
        //   backgroundColor: Colors.grey[800],
        //   body: OrgComponents.generateAppBody(), 
        // ),
    );
  }
}