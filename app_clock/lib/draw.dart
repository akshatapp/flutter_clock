import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:app_clock/constants.dart';

class HandPainter extends CustomPainter {
  double handSize;
  double lineWidth;
  double angleRadians;
  double offsetX;
  double offsetY;
  Color color;
  HandType type;
  bool shadow;

  HandPainter(
      {@required this.handSize,
      @required this.lineWidth,
      @required this.angleRadians,
      @required this.color,
      @required this.type,
      @required this.shadow,
      @required this.offsetX,
      @required this.offsetY});

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;

    final angle = angleRadians - math.pi / 2.0;

    final length = size.shortestSide * 0.5 * handSize;

    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;

    // draw shadow

    if (shadow == true) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.05)
        ..strokeWidth = lineWidth
        ..strokeCap = StrokeCap.round;

      // hand shadow position

      if (type == HandType.seconds) {
        //paints seconds hand shadow with greater offset value
        final shadowPosition = center +
            Offset(math.cos(angle), math.sin(angle)) * length +
            Offset(offsetX, offsetX);

        canvas.drawLine(
            center + Offset(offsetX, offsetX), shadowPosition, shadowPaint);
      } else {
        //paints minutes and hour hand shadow with lesser offset value

        final shadowPosition = center +
            Offset(math.cos(angle), math.sin(angle)) * length +
            Offset(offsetX, offsetY);

        canvas.drawLine(
            center + Offset(offsetX, offsetY), shadowPosition, shadowPaint);
      }

      // paints seconds hand  tail shadow

      if (type == HandType.seconds) {
        canvas.drawLine(
            center + Offset(offsetX, offsetX),
            center +
                Offset(-math.cos(angle), -math.sin(angle)) * (length * 0.3) +
                Offset(offsetX, offsetX),
            shadowPaint);
      }
    }

    // draw hand position

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, position, linePaint);

    // draw seconds hand tail

    if (type == HandType.seconds) {
      canvas.drawLine(
          center,
          center + Offset(-math.cos(angle), -math.sin(angle)) * (length * 0.3),
          linePaint);
    }
  }

  @override
  bool shouldRepaint(HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
