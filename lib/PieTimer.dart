import 'package:flutter/material.dart';
import 'CustomTimerPainter.dart';

enum PieTimerStatus {
  none, 
  playing, 
  paused 
}

class PieTimer extends StatefulWidget {
  final Duration duration;

  PieTimer(int hrs, int min, int sec)
      : duration = new Duration(hours: hrs, minutes: min, seconds: sec);

  @override
  State createState() => new _PieTimerState();
}

class _PieTimerState extends State<PieTimer> with TickerProviderStateMixin {
  AnimationController _controller;
  PieTimerStatus _status;           // timer status separate from the animation 

  // called once when the object is inserted into the tree
  @override
  void initState() {
    super.initState();
    _status = PieTimerStatus.none; 
    _controller = AnimationController(
        vsync:
            this, // the ticker controller uses to schedule animations - SingleTickerProviderStateMixin
        duration: widget.duration // time for the animation to happen
        );
  }

  String get timerString {
    Duration dur = _controller.duration * _controller.value;
    return '${dur.inMinutes}:${(dur.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  // detects status of animation and returns the timer status 
  void _switchStatus() {
    print("Status at call was:");
    print(_status); 
    switch (_status) {
      case PieTimerStatus.none:
      case PieTimerStatus.paused: {
        _status = PieTimerStatus.playing;
        //print(_status);
        _controller.reverse(from: (_controller.value == 0.0) ? 1.0 : _controller.value);
      }
      break; 
      case PieTimerStatus.playing: {
        //print("playing");
        _status = PieTimerStatus.paused;
        _controller.stop(); 
        ///print(_status);
      } 
      break; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
        body: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
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
                                      child: Stack(children: <Widget>[
                                        Positioned.fill(
                                          child: CustomPaint(
                                              painter: CustomTimerPainter(
                                                  animation: _controller,
                                                  backgroundColor: Colors.green,
                                                  color: Colors.black)),
                                        ),
                                        Align(
                                            alignment: FractionalOffset.center,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    timerString,
                                                    style: TextStyle(
                                                        fontSize: 112.0,
                                                        color: Colors.white),
                                                  ),
                                                ])),
                                        AnimatedBuilder(
                                            animation: _controller,
                                            builder: (context, child) {
                                              return FloatingActionButton
                                                  .extended(
                                                      onPressed: _switchStatus,
                                                      icon: Icon(_controller.isAnimating ? Icons.pause : Icons.play_arrow),
                                                      label: Text(_controller
                                                              .isAnimating
                                                          ? "Pause"
                                                          : "Play"));
                                            }),
                                      ]))))
                        ]))
              ]);
            }));
  }
}
