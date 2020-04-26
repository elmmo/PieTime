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
      home: DefaultTabController(
        length: 3,  
        child: Scaffold(
          appBar: OrgComponents.generateAppBar(
            TabBar(tabs: <Widget>[
              Tab(text: "Hours"),
              Tab(text: "Minutes"),
              Tab(text: "Seconds")
            ],)
          ), 
          drawer: OrgComponents.generateSideDrawer(), 
          body: TabBarView(children: <Widget>[
            SetTime(),
            Text("World"),
            Text(":D")
          ],)
        )
      )
      
      
      // home page code 
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