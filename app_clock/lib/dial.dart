import 'dart:math';
import 'package:flutter/material.dart';

// Paints Analog Clock Dial
class ClockDial extends CustomPainter {
  final hourTickHeight = 10.0;
  final minTickHeight = 5.0;
  final hourTickWidth = 3.0;
  final minTickWidth = 1.0;
  final color;

  final Paint tickPaint;
  ClockDial(this.color) : tickPaint = new Paint()..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    var tickHeight;
    final angle = 2 * pi / 60;
    final radius = size.width / 2;

    canvas.save();

    canvas.translate(radius, radius);
    for (var i = 0; i < 60; i++) {
      tickHeight = i % 5 == 0 ? hourTickHeight : minTickHeight;
      tickPaint.strokeWidth = i % 5 == 0 ? hourTickWidth : minTickWidth;

      canvas.drawLine(
          Offset(0.0, -radius), Offset(0.0, -radius + tickHeight), tickPaint);
      canvas.rotate(angle);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
