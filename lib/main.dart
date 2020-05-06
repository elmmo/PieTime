import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'OrgComponents.dart';
import 'timer_face/SetTime.dart';
import 'TimeKeeper.dart';

void main() => runApp(new PieTimerApp());

class PieTimerApp extends StatefulWidget {

  @override
  State createState() => new _PieTimerAppState();
}

// entry for the rest of the app 
class _PieTimerAppState extends State<PieTimerApp> {
  Duration _maxTime = Duration.zero; 

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
      routes: {
        '/setTime': (BuildContext context) => SetTime(_sendDuration, context), 
      },
      home: Builder(
        builder: (context) => TimeKeeper(_maxTime, child: OrgComponents())
      )
    );
  }

  // callback for transferring duration across classes 
  void _sendDuration(Duration newTime, BuildContext context) {
    setState(() {
      _maxTime = newTime; 
    }); 
    Navigator.pop(context); 
  }
}