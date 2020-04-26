import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'CustomTimerPainter.dart';
import 'Util.dart';

enum PieTimerStatus { none, playing, paused }

class PieTimer extends StatefulWidget {
  @override
  State createState() => new _PieTimerState();
}

class _PieTimerState extends State<PieTimer> with TickerProviderStateMixin {
  AnimationController _controller;
  PieTimerStatus _status; // timer status separate from the animation
  Duration _duration; 

  // called once when the object is inserted into the tree
  @override
  void initState() {
    super.initState();
    _status = PieTimerStatus.none;
    _controller = AnimationController(
        vsync:
            this, // the ticker controller uses to schedule animations - SingleTickerProviderStateMixin
        duration: new Duration(hours: 0, minutes: 0, seconds: 0) // time for the animation to happen
      )
      ..addStatusListener((animationStatus) {
        // listens for changes to the animation to update the timer status
        if (animationStatus == AnimationStatus.dismissed) {
          _vibrateAlert(5);
          getDialog(context, "Timer Complete", "The timer is finished."); 
          _switchStatus(PieTimerStatus.none);
        }
      });
  }

  // returns the time remaining on the clock
  String get timerString {
    Duration dur = _controller.duration * _controller.value;
    return '${dur.inMinutes}:${(dur.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  // detects status of animation and returns the timer status
  // if optional param supplied, switch to that state with no change in animation
  // optional param only meant to be used for none state
  void _switchStatus([PieTimerStatus requestStatus]) {
    PieTimerStatus switchTo;
    if (requestStatus == null) {
      switch (_status) {
        case PieTimerStatus.none:
        case PieTimerStatus.paused:
          {
            switchTo = PieTimerStatus.playing;
            _controller.reverse(
                from: (_controller.value == 0.0) ? 1.0 : _controller.value);
          }
          break;
        case PieTimerStatus.playing:
          {
            switchTo = PieTimerStatus.paused;
            _controller.stop();
          }
          break;
      }
    } else {
      switchTo = requestStatus;
    }
    // sets the state of status to whatever was determined previously
    setState(() {
      _status = switchTo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
            animation: _controller,
           builder: (context, child) => 
              positionWidgets([
                generatePie(),
                generateTimerText(timerString),
                generateToggleButton()])
        ),
        floatingActionButton: Builder(
          builder: (BuildContext context) => new FloatingActionButton(
                onPressed: () async {
                  Duration duration = await showSetTimeDialog();
                  Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text("Chose duration: $duration")));
                  setState(() {
                    _duration = duration; 
                    _controller.duration = _duration; 
                  });
                },
                tooltip: 'Popup Duration Picker',
                child: new Icon(Icons.add),
            ))
      );  
    }

 // set time for instantiating PieTimer 
  Future showSetTimeDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return AlertDialog(
            title: new Text("Set New Timer"),
            content: DurationPicker(
              duration: new Duration(seconds:10),
              onChange: (val) {
                this.setState(() => _duration = val);
              },
              snapToMins: 5.0,
            ),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Confirm"),
                  color: Colors.cyan[800],
                  onPressed: () {
                    Navigator.pop(builderContext, _duration);
                  })
            ]);
      });
  }

  // creates the floating action button that triggers the timer
  Widget generateToggleButton() {
    return FloatingActionButton.extended(
        onPressed: _switchStatus,
        icon: Icon(
            _status == PieTimerStatus.playing ? Icons.pause : Icons.play_arrow),
        label: Text(_status == PieTimerStatus.playing ? "Pause" : "Play"));
  }

  // creates the main circle graphic
  Widget generatePie() {
    return Positioned.fill(
      child: CustomPaint(
          painter:
              CustomTimerPainter(
                animation: _controller, color: Colors.red[300])),
    );
  }

  // creates and positions the text in the middle of the pie
  Widget generateTimerText(text) {
    return Align(
        alignment: FractionalOffset.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(fontSize: 70.0, color: Colors.white),
              )]
            ));
  }

  // positions the widgets passed to it in the first param
  Widget positionWidgets(List<Widget> widgArr) {
    return Stack(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Align(
                        alignment: FractionalOffset.center,
                        child: AspectRatio(
                            aspectRatio: 1.0, 
                            child: Stack(children: widgArr))))
              ]))
    ]);
  }

  // run the vibration for the alert
  void _vibrateAlert(int vibrationRepetition) {
    // run the vibration
    for (var i = 0; i < vibrationRepetition; i++) {
      HapticFeedback.mediumImpact();
      sleep(const Duration(milliseconds: 300));
    }
  }
}
