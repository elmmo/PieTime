import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

// Hamburger menu on the Appbar to the left
class OrgComponents {
  static Widget generateSideDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // header
          DrawerHeader(
            child: Text(
              'Drawer Header',
              style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Colors.grey[800],
            ),
          ),
          // items within menu
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
    );
  }

  // standard app bar across PieTime
  static Widget generateAppBar() {
    return AppBar(
      title: Text(
        'PieTime',
        // apply the text themes from ui branch
        // style: arr.apply(),
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
    );
  }

  // everything below the app bar on the main page 
  static Widget generateAppBody() {
    return Container(
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
            decoration:
                BoxDecoration(color: Colors.red[400], shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
