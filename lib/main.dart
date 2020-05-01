import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'OrgComponents.dart';
import 'timer_face/SetTime.dart';
import 'timer_face/PieTimer.dart';

void main() => runApp(new PieTimerApp());

class PieTimerApp extends StatefulWidget {

  @override
  State createState() => new _PieTimerAppState();
}

// entry for the rest of the app 
class _PieTimerAppState extends State<PieTimerApp> {
  Duration _timerDuration;
  PieTimer _timer; 

  @override
  void initState() {
    _timerDuration = new Duration(seconds: 0);
    _timer = new PieTimer(_timerDuration); 
    super.initState();
  }

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
        builder: (context) => Scaffold(
          drawer: OrgComponents.generateSideDrawer(),
          appBar: OrgComponents.generateAppBar(context),
          // Contains everything below the Appbar
          backgroundColor: Colors.grey[800],
          body: OrgComponents.generateAppBody(Theme.of(context), _timerDuration, _timer), 
        ),
      )
    );
  }

  // callback for transferring duration across classes 
  void _sendDuration(Duration newTime, BuildContext context) {
    setState(() {
      _timerDuration = newTime; 
      _timer = new PieTimer(_timerDuration); 
    }); 
    Navigator.pop(context); 
  }
}