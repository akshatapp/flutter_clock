import 'dart:ui';
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:app_clock/dial.dart';
import 'package:app_clock/hand.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:app_clock/constants.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

final radiansPerHour = radians(360 / 12);
final radiansPerTick = radians(360 / 60);

class AppClock extends StatefulWidget {
  final ClockModel model;
  AppClock(this.model);

  @override
  _AppClockState createState() => _AppClockState();
}

class _AppClockState extends State<AppClock>
    with SingleTickerProviderStateMixin {
  DateTime _now;
  Timer _timer;
  String _temperature = ' ';
  String _temperatureRange = ' ';
  String _condition = ' ';
  String _location = ' ';
  String _weatherIcon = ' ';
  String _message = ' ';

  AnimationController _animationController;
  Animation<Offset> _offsetAnimationRight;
  Animation<Offset> _offsetAnimationLeft;
  Animation<Offset> boxAnimation;

  CurvedAnimation myCurve;

  @override
  void initState() {
    super.initState();
    _landScapeModeOnly();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();

    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this)
          ..repeat(reverse: true);

    myCurve = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutBack);
    _offsetAnimationLeft =
        Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(-0.85, 0.0))
            .animate(myCurve);

    _offsetAnimationRight =
        Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.85, 0.0))
            .animate(myCurve);
  }

  @override
  void didUpdateWidget(AppClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _resetMode();
    _timer?.cancel();
    _animationController.dispose();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(
      () {
        _temperature = widget.model.temperatureString;
        _temperatureRange =
            '(${widget.model.low} - ${widget.model.highString})';
        _condition = widget.model.weatherString.toUpperCase();
        _weatherIcon = _getWeatherIcon();
        _location = widget.model.location;
        if (widget.model.weatherCondition == WeatherCondition.thunderstorm) {
          _message = 'looks like there is a thunderstorm coming';
        } else {
          _message = 'its going to be $_condition today';
        }
      },
    );
  }

  void _updateTime() {
    setState(
      () {
        _now = DateTime.now();
        _timer = Timer(
          Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
          _updateTime,
        );
      },
    );
  }

  void _landScapeModeOnly() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );
  }

  void _resetMode() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ],
    );
  }

  // gets the weather icon from the string constants
  String _getWeatherIcon() {
    switch (widget.model.weatherCondition) {
      case WeatherCondition.cloudy:
        return cloudyIcon;
        break;
      case WeatherCondition.foggy:
        return foggyIcon;
        break;
      case WeatherCondition.rainy:
        return rainyIcon;
        break;
      case WeatherCondition.snowy:
        return snowyIcon;
        break;
      case WeatherCondition.sunny:
        return sunnyIcon;
        break;
      case WeatherCondition.thunderstorm:
        return thunderstormIcon;
        break;
      case WeatherCondition.windy:
        return windyIcon;
        break;
      default:
        return sunnyIcon;
    }
  }

  // Paints Analog Clock Dial
  Widget _buildClockDial(BuildContext context, ThemeData customTheme) {
    return Center(
      child: Container(
        width: getClockDialSize(context),
        height: getClockDialSize(context),
        padding: EdgeInsets.all(getPadding(context) * 1.5),
        child: CustomPaint(
          painter: ClockDial(customTheme.accentColor),
        ),
      ),
    );
  }

  // Analog Clock Center White Circle
  Widget _buildCenterCircle(BuildContext context) {
    return Center(
      child: Container(
        width: getCircleSize(context),
        height: getCircleSize(context),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 2.0,
                offset: Offset(1.0, 1.0),
                color: Colors.black54)
          ],
        ),
      ),
    );
  }

  // Builds Resuable Info Widget to display API information on screen
  Widget _buildInfo(DefaultTextStyle info, double left, double top,
      double right, double bottom) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: info,
    );
  }

  // Components of Digital Clock
  Widget _buildCenterBox(String value, TextStyle style, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: kCenterBoxColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black38,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0))
        ],
      ),
      height: getBoxSize(context),
      width: getBoxSize(context),
      child: Center(
        child: Text(
          value,
          style: style,
        ),
      ),
    );
  }

  Widget _buildBox(double angle, Color color, String value, TextStyle style,
      BuildContext context) {
    return Transform.rotate(
      angle: angle, //3 degree rotation converted in radians
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: color,
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0))
          ],
        ),
        height: getBoxSize(context),
        width: getBoxSize(context),
        child: Center(
          child: Text(
            value,
            style: style,
          ),
        ),
      ),
    );
  }

  // builds Animated Box Digital Clock at bottom right corner
  Widget _buildAnimatedClock(String hrs, String min, String sec,
      TextStyle txtStyle, BuildContext context) {
    return Positioned(
      right: getPadding(context) * 1.5,
      bottom: getPadding(context) * 1.5,
      child: Container(
        width: getClockWidth(context),
        height: getClockHeight(context),
        child: ExcludeSemantics(
          child: Center(
            child: Stack(
              children: <Widget>[
                SlideTransition(
                  position: _offsetAnimationLeft,
                  child:
                      _buildBox(kAngle, kLeftBoxColor, hrs, txtStyle, context),
                ),
                SlideTransition(
                  position: _offsetAnimationRight,
                  child: _buildBox(
                      -kAngle, kRightBoxColor, sec, txtStyle, context),
                ),
                _buildCenterBox(min, txtStyle, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //ThemeData
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            primaryColor: kPrimaryLight,
            highlightColor: kHighlightLight,
            accentColor: kAccentLight,
            backgroundColor: kBackgroundLight,
          )
        : Theme.of(context).copyWith(
            primaryColor: kPrimaryDark,
            highlightColor: kHighlightDark,
            accentColor: kAccentDark,
            backgroundColor: kBackgroundDark,
          );

    final txtStyle = getTxtStyle(context);
    final smallTxtStyle = getSmallTxtStyle(context, customTheme);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final shadowOffsetX = getShadowOffsetX(context);
    final shadowOffsetY = getShadowOffsetY(context);

    //final time12 = DateFormat('h m').format(DateTime.now());
    //final suffix = _now.hour >= 12 ? " PM" : " AM";
    final time12 = DateFormat.jm().format(DateTime.now());
    final time24 = DateFormat.Hms().format(DateTime.now());
    final marker = DateFormat('a').format(DateTime.now());

    final hrs =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_now);
    final min = DateFormat('mm').format(_now);
    final sec =
        widget.model.is24HourFormat ? DateFormat('ss').format(_now) : marker;

    //Text Widget to display API temperatureInfo
    final temperatureInfo = DefaultTextStyle(
      style: smallTxtStyle,
      child: ExcludeSemantics(
        child: Text(_temperatureRange),
      ),
    );

    //Text Widget to display API locationInfo
    final locationInfo = DefaultTextStyle(
      style: smallTxtStyle,
      child: ExcludeSemantics(
        child: Text(locationIcon + _location),
      ),
    );

    //Text Widget to display API weatherInfo
    final weatherInfo = DefaultTextStyle(
      style: smallTxtStyle,
      child: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          ExcludeSemantics(
            child: Text(_condition + _weatherIcon),
          ),
          ExcludeSemantics(
            child: Text(_temperature),
          ),
        ],
      ),
    );

    return Semantics.fromProperties(
      //Accessibility
      properties: SemanticsProperties(
        //TalkBack Messsage
        label:
            'It is ${widget.model.is24HourFormat ? time24 : time12}, the temperature in $_location is $_temperature, $_message.',
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: Stack(
          children: <Widget>[
            _buildClockDial(context, customTheme),

            //paints clock hand
            DrawHand(
                handType: HandType.hour, //clock hand type enum
                color: customTheme.primaryColor,
                paintShadow:
                    true, // paint shadow for clock hand is optional (set false to hide shadow)
                shadowOffsetX: shadowOffsetX, //shadow offset x value
                shadowOffsetY: shadowOffsetY, //shadow offset y value
                thickness: width > height
                    ? getHandThickness(context)
                    : getHandThickness(context) * 0.5,
                size: kHrsHandLength,
                angleRadians: _now.hour * radiansPerHour +
                    (_now.minute / 60) * radiansPerHour),
            DrawHand(
                handType: HandType.minutes,
                color: customTheme.highlightColor,
                paintShadow: true,
                shadowOffsetX: shadowOffsetX,
                shadowOffsetY: shadowOffsetY,
                thickness: width > height
                    ? getHandThickness(context)
                    : getHandThickness(context) * 0.5,
                size: kMinHandLength,
                angleRadians: _now.minute * radiansPerTick),
            DrawHand(
                handType: HandType.seconds,
                color: customTheme.accentColor,
                paintShadow: true,
                shadowOffsetX: shadowOffsetX,
                shadowOffsetY: shadowOffsetY,
                thickness: kSecondHandThickness,
                size: kSecHandLength,
                angleRadians: _now.second * radiansPerTick),
            _buildCenterCircle(context),
            _buildInfo(
              locationInfo,
              getPadding(context),
              null,
              null,
              getPadding(context),
            ),
            _buildInfo(weatherInfo, getPadding(context), getPadding(context),
                null, null),
            _buildInfo(temperatureInfo, null, getPadding(context),
                getPadding(context), null),
            _buildAnimatedClock(hrs, min, sec, txtStyle, context),
          ],
        ),
      ),
    );
  }
}
