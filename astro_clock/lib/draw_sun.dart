import 'dart:math';

import 'package:flutter/material.dart';


class DrawSun extends CustomPainter {
  Paint _paint;
  double angleRad;

  DrawSun(double angleRadians) {
    _paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
    angleRad = angleRadians;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var mx = size.width/2;
    var my = size.height;
    var radius = size.height-(size.height/3.8);

    var x = mx + (radius * cos(angleRad));
    var y = my + (radius * sin(angleRad));

    canvas.drawCircle(Offset(x, y), 30.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}