import 'dart:math';

import 'package:flutter/material.dart';


class DrawMoon extends CustomPainter {
  Paint _paint;
  double angleRad;

  DrawMoon(double angleRadians) {
    _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;
    angleRad = angleRadians;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var mx = size.width/2;
    var my = size.height;
    var radius = size.height-(size.height/3.8);

    var x = mx + (radius * cos(angleRad));
    var y = my + (radius * sin(angleRad));

    canvas.drawCircle(Offset(x, y), 25.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}