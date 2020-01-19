import 'package:app_clock/draw.dart';
import 'package:flutter/material.dart';
import 'package:app_clock/constants.dart';

class DrawHand extends StatelessWidget {
  final double thickness;
  final double size;
  final double angleRadians;
  final Color color;
  final HandType handType;
  final bool paintShadow;
  final double shadowOffsetX;
  final double shadowOffsetY;

  DrawHand(
      {@required this.color,
      @required this.thickness,
      @required this.size,
      @required this.angleRadians,
      @required this.handType,
      @required this.paintShadow,
      @required this.shadowOffsetX,
      @required this.shadowOffsetY});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: HandPainter(
              shadow: paintShadow,
              offsetX: shadowOffsetX,
              offsetY: shadowOffsetY,
              type: handType,
              lineWidth: thickness,
              handSize: size,
              angleRadians: angleRadians,
              color: color),
        ),
      ),
    );
  }
}
