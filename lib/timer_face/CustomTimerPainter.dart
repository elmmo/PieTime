import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomTimerPainter extends CustomPainter {

  CustomTimerPainter({
    this.animation, 
    this.backgroundColor, 
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation; 
  final Color backgroundColor, color; 

  @override 
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke 
      ..color = new Color(0xFF0099FF)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.hardLight;

      paint.color = color; 
      double progress = (1.0 - animation.value) * 2 * math.pi; 
      canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, true, paint); 
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value;
  }

}