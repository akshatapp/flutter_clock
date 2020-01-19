import 'package:app_clock/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter_clock_helper/customizer.dart';

void main() => runApp(ClockCustomizer((ClockModel model) => AppClock(model)));
