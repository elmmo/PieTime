// Main interface for the app
// Alyssa Fusato, 4/6/20

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(new PieTimerApp());

// should be stateless? there's no reason why it should have state 
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
          // Hamburger menu on the Appbar to the left
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    'Drawer Header',
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                  ),
                ),
                ListTile(
                  title: Text('Item 1'),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Item 2'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text(
              'PieTime',
              style: GoogleFonts.almarai(
                textStyle: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.w700,),
              ),
            ),
            backgroundColor: Colors.grey[900],
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                // Plus icon on the Appbar to the right
                child: Icon(
                  Icons.add,
                  size: 26.0,
                ),
              ),
            ],
          ),
          // Contains everything below the Appbar
          backgroundColor: Colors.grey[800],
          body: Container(
            margin: EdgeInsets.symmetric(vertical: 80.0),
            // Dotted border for each hour tick mark
            child: DottedBorder(
              color: Colors.white,
              radius: Radius.circular(12),
              dashPattern: [2, 67.7],
              strokeWidth: 20,
              borderType: BorderType.Circle,

              // Dotted border for each hour minute mark
              child: DottedBorder(
                color: Colors.white,
                radius: Radius.circular(12),
                dashPattern: [2, 11.755],
                strokeWidth: 8,
                borderType: BorderType.Circle,
                padding: EdgeInsets.all(6),
                // Red timer circle
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                      color: Colors.red[400], shape: BoxShape.circle),
                ),
              ),
            ),
          )),
    );
  }
}