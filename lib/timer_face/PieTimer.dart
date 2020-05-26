import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:io';
import 'CustomTimerPainter.dart';
import 'Util.dart';
import '../Theme.dart';

enum PieTimerStatus { none, playing, paused }

enum PieTimerComponent { pie, timerText, toggleButton }

class PieTimer extends StatefulWidget {
  final Duration duration;

  PieTimer(this.duration);

  @override
  State createState() => new _PieTimerState();
}

class _PieTimerState extends State<PieTimer> with TickerProviderStateMixin {
  AnimationController _controller;
  PieTimerStatus _status; // timer status separate from the animation
  Map<PieTimerComponent, Widget> _buildStack;

  // called once when the object is inserted into the tree
  @override
  void initState() {
    super.initState();
    _status = PieTimerStatus.none;
    _controller = AnimationController(
        vsync:
            this, // the ticker controller uses to schedule animations - SingleTickerProviderStateMixin
        duration: this.widget.duration // time for the animation to happen
        )
      ..addStatusListener((animationStatus) {
        // listens for changes to the animation to update the timer status
        if (animationStatus == AnimationStatus.dismissed) {
          _vibrateAlert(5);
          getDialog(context, "Timer Complete", "The timer is finished.");
          _switchStatus(PieTimerStatus.none);
        }
      });
    _buildStack = new Map();
  }

  // returns the time remaining on the clock
  String get timerString {
    Duration dur = (_controller.value == 0)
        ? _controller.duration
        : _controller.duration * _controller.value;
    if (dur.inHours == 0) {
      return '${(dur.inMinutes).toString()}:${(dur.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      return '${(dur.inHours).toString()}:${(dur.inMinutes % 60).toString().padLeft(2, '0')}:${(dur.inSeconds % 60).toString().padLeft(2, '0')}';
    }
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
    generatePie();
    generateToggleButton();
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
            animation: getUpdate(),
            builder: (context, child) =>
                // buildStack pushes all static values to be positioned and separately adds
                // elements that need to be rebuilt every time the animation controller changes
                positionWidgets(_buildStack.values.toList() +
                    [generateTimerText(timerString)])));
  }

  // creates the floating action button that triggers the timer
  void generateToggleButton() {
    if (_controller.duration > Duration(milliseconds: 0)) {
      FloatingActionButton button = FloatingActionButton.extended(
          onPressed: _switchStatus,
          icon: Icon(_status == PieTimerStatus.playing
              ? Icons.pause
              : Icons.play_arrow),
          foregroundColor: Colors.white,
          backgroundColor: CustomColor.newTask,
          label: Text(_status == PieTimerStatus.playing ? "Pause" : "Play",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
      _buildStack[PieTimerComponent.toggleButton] = button;
    }
  }

  // creates the main circle graphic
  void generatePie() {
    Widget pie = Positioned.fill(
      child: CustomPaint(
          painter: CustomTimerPainter(
              animation: _controller, color: Colors.blueGrey[700])),
    );
    _buildStack[PieTimerComponent.pie] = pie;
  }

  // creates and positions the text in the middle of the pie
  Widget generateTimerText(text) {
    Color timerTextbg = Colors.grey[600];
    Widget timerText = Align(
        alignment: FractionalOffset.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      color: timerTextbg,
                      backgroundBlendMode: BlendMode.multiply,
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      )),
                child: Padding(
                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 40.0, color: Colors.white),
                  )
                ,)
                  ),
            ]));
    return timerText;
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

  // run the vibration for the alert
  void _vibrateAlert(int vibrationRepetition) {
    // run the vibration
    for (var i = 0; i < vibrationRepetition; i++) {
      Vibration.vibrate(duration: 150, amplitude: 250);
      sleep(const Duration(milliseconds: 200));
    }
  }

  // update after setTime
  AnimationController getUpdate() {
    setState(() {
      _controller.duration = this.widget.duration;
      generateToggleButton();
    });
    return _controller;
  }
}
