import 'package:flutter/material.dart';

enum HandType { hour, minutes, seconds }

// Constants

const Color kCenterBoxColor = Color(0xFFD50000);
const Color kLeftBoxColor = Color(0xFF1976D2);
const Color kRightBoxColor = Color(0xFFFFA726);

const Color kPrimaryLight = Color(0xFF3F51B5);
const Color kHighlightLight = Color(0xFF9FA8DA);
const Color kAccentLight = Color(0xFF5C6BC0);
const Color kBackgroundLight = Color(0xFFFFFFF);

const Color kPrimaryDark = Color(0xFFD2E3FC);
const Color kHighlightDark = Color(0xFF4285F4);
const Color kAccentDark = Color(0xFF8AB4F8);
const Color kBackgroundDark = Color(0xFF3C4043);

const String cloudyIcon = " ☁️ ";
const String foggyIcon = " 🌫️ ";
const String rainyIcon = " 🌧️ ";
const String snowyIcon = " 🌨️ ";
const String sunnyIcon = " 🌞️ ";
const String thunderstormIcon = " 🌩️ ";
const String windyIcon = " 🍃️ ";

const String locationIcon = "🌎️ ";

const double kAngle = 0.0523;

const double kSecondHandThickness = 2.0;

const double kHrsHandLength = 0.3;
const double kMinHandLength = 0.75;
const double kSecHandLength = 0.95;

// Helper Methods

TextStyle getTxtStyle(BuildContext context) {
  final fontSize = (MediaQuery.of(context).size.width / 25).ceilToDouble();
  return TextStyle(fontSize: fontSize, color: Colors.white);
}

TextStyle getSmallTxtStyle(BuildContext context, customTheme) {
  final smallFontSize = (MediaQuery.of(context).size.width / 35).ceilToDouble();
  return TextStyle(fontSize: smallFontSize, color: customTheme.primaryColor);
}

double getHandThickness(BuildContext context) {
  double shortSide = MediaQuery.of(context).size.shortestSide;
  return (shortSide * 0.040).roundToDouble();
}

double getShadowOffsetX(BuildContext context) {
  double shortSide = MediaQuery.of(context).size.shortestSide;
  return ((shortSide * 0.025).roundToDouble()) * 1.5;
}

double getShadowOffsetY(BuildContext context) {
  double shortSide = MediaQuery.of(context).size.shortestSide;
  return ((shortSide * 0.025).roundToDouble()) * 0.5;
}

double getPadding(BuildContext context) {
  double shortSide = MediaQuery.of(context).size.shortestSide;
  return (shortSide * 0.025).roundToDouble();
}

double getClockDialSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  double shortSide = MediaQuery.of(context).size.shortestSide;

  if (height > width) {
    return (shortSide * 0.6).floorToDouble();
  }
  return (shortSide * 0.851).floorToDouble();
}

double getClockHeight(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  double shortSide = MediaQuery.of(context).size.shortestSide;

  if (width > height) {
    return (shortSide * 0.12).floorToDouble();
  }
  return ((shortSide * 0.12) * 0.6).floorToDouble();
}

double getClockWidth(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  double shortSide = MediaQuery.of(context).size.shortestSide;

  if (width > height) {
    return (shortSide * 0.365).floorToDouble();
  }
  return ((shortSide * 0.365) * 0.6).floorToDouble();
}

double getBoxSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  if (width > height) {
    return (height / 7).floorToDouble();
  }
  return ((width / 7) * 0.6).floorToDouble();
}

double getCircleSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  double shortSide = MediaQuery.of(context).size.shortestSide;

  if (width > height) {
    return (shortSide * 0.075).floorToDouble();
  }

  return ((shortSide * 0.075) * 0.6).floorToDouble();
}
