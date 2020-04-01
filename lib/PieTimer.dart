import 'package:flutter/material.dart';

class PieTimer extends StatefulWidget { 
  final Duration duration; 

  PieTimer(int hrs, int min, int sec) :
    duration = new Duration(hours: hrs, minutes: min, seconds: sec); 

  @override
  State createState() => new PieTimerState(); 
}

class PieTimerState extends State<PieTimer>
  with TickerProviderStateMixin {
  AnimationController _controller; 
  int enteredTimeSec = 0; 

  // called once when the object is inserted into the tree
  @override
  void initState() { 
    super.initState();
    _controller = AnimationController(
      vsync: this, // the ticker controller uses to schedule animations - SingleTickerProviderStateMixin
      duration: widget.duration // time for the animation to happen
    );
  }

  // might need to implement didUpdateWidget for implicit animations 

  // will release resources used by the PieTimer when the timer is no longer needed
  // will also stop any active animations 
  @override
  void dispose() { 
    _controller.dispose(); 
    super.dispose(); 
  }

  @override 
  Widget build(BuildContext context) {
    
  }


}

