import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'OrgComponents.dart';

void main() => runApp(new PieTimerApp());


// entry for the rest of the app 
class PieTimerApp extends StatefulWidget {
  @override
  _PieTimerState createState() => _PieTimerState();
}

class _PieTimerState extends State<PieTimerApp> {
  double padValue = 0;

  // builds the main container widget 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pie Timer",
      theme: ThemeData(
        textTheme: GoogleFonts.almaraiTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
          drawer: OrgComponents.generateSideDrawer(),
          appBar: OrgComponents.generateAppBar(),
          // Contains everything below the Appbar
          backgroundColor: Colors.grey[800],
          body: OrgComponents.generateAppBody(), 
        ),
    );
  }
}