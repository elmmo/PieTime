import 'package:flutter/material.dart';
import 'package:pie_time/theme.dart';
// import 'package:flutter/services.dart';
import 'dart:io';
import 'CustomTimerPainter.dart';
import 'package:vibration/vibration.dart';

enum PieTimerStatus { none, playing, paused }

class PieTimer extends StatefulWidget {
  final Duration duration;

  PieTimer(int hrs, int min, int sec)
      : duration = new Duration(hours: hrs, minutes: min, seconds: sec);

  @override
  State createState() => new _PieTimerState();
}

class _PieTimerState extends State<PieTimer> with TickerProviderStateMixin {
  AnimationController _controller;
  PieTimerStatus _status; // timer status separate from the animation

  // called once when the object is inserted into the tree
  @override
  void initState() {
    super.initState();
    _status = PieTimerStatus.none;
    _controller = AnimationController(
        vsync:
            this, // the ticker controller uses to schedule animations - SingleTickerProviderStateMixin
        duration: widget.duration // time for the animation to happen
        )
      ..addStatusListener((animationStatus) {
        // listens for changes to the animation to update the timer status
        if (animationStatus == AnimationStatus.dismissed) {
          _vibrateAlert(5);
          _showDialog();
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
            builder: (context, child) => positionWidgets(
                [generatePie(), generateTimerText(), generateToggleButton()])));
  }

  // creates the floating action button that triggers the timer
  Widget generateToggleButton() {
    return FloatingActionButton.extended(
        // backgroundColor: Theme.of(context).buttonColor,
        backgroundColor: CustomTheme.of(context).focusColor,
        onPressed: _switchStatus,
        icon: Icon(
            _status == PieTimerStatus.playing ? Icons.pause : Icons.play_arrow),
        label: Text(_status == PieTimerStatus.playing ? "Pause" : "Play",));
  }

  // creates the main circle graphic
  Widget generatePie() {
    return Positioned.fill(
      child: CustomPaint(
          painter: CustomTimerPainter(
              animation: _controller, color: Colors.red[300])),
    );
  }

  // creates and positions the text in the middle of the pie
  Widget generateTimerText() {
    return Align(
        alignment: FractionalOffset.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                timerString,
                style: TextStyle(fontSize: 70.0, color: Colors.white),
              )
            ]));
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
                            aspectRatio: 1.0, child: Stack(children: widgArr))))
              ]))
    ]);
  }

  // show alert for the end of the timer
  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Timer Complete"),
              content: new Text("The timer is finished."),
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              actions: <Widget>[
                new FlatButton(
                    child: new Text("Ok"),
                    color: Theme.of(context).buttonColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  // run the vibration for the alert
  void _vibrateAlert(int vibrationRepetition) {
    // run the vibration
    for (var i = 0; i < vibrationRepetition; i++) {
      Vibration.vibrate(duration: 150, amplitude: 250);
      sleep(const Duration(milliseconds: 200));
    }
  }
}
