import 'dart:math';

import 'package:flutter/material.dart';


class DrawMoon extends CustomPainter {
  Paint _paint;
  double angleRad;

  DrawMoon(double angleRadians) {
    _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
    angleRad = angleRadians;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var mx = size.width/2;
    var my = size.height;

    var x = mx + (240 * cos(angleRad));
    var y = my + (240 * sin(angleRad));

    canvas.drawCircle(Offset(x, y), 30.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}