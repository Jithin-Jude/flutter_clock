// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:astro_clock/draw_moon.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;


import './draw_sun.dart';


/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 24);

enum _Element {
  backgroundDay,
  backgroundNight,
  frontMountainDay,
  frontMountainNight,
  text,
  shadow,
}

final _lightTheme = {
  _Element.backgroundDay: AssetImage("assets/images/bg_day_light.png"),
  _Element.frontMountainDay: AssetImage('assets/images/bg_day_front_hill_light.png'),
  _Element.backgroundNight: AssetImage("assets/images/bg_night_light.png"),
  _Element.frontMountainNight: AssetImage('assets/images/bg_night_front_hill_light.png'),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.backgroundDay: AssetImage("assets/images/bg_day_dark.png"),
  _Element.frontMountainDay: AssetImage('assets/images/bg_day_front_hill_dark.png'),
  _Element.backgroundNight: AssetImage("assets/images/bg_night_dark.png"),
  _Element.frontMountainNight: AssetImage('assets/images/bg_night_front_hill_dark.png'),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

/// A basic digital clock.
///
/// You can do better than this!
class AstroClock extends StatefulWidget {
  const AstroClock(this.model);

  final ClockModel model;

  @override
  _AstroClockState createState() => _AstroClockState();
}

class _AstroClockState extends State<AstroClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AstroClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
    DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final hourForTheme = int.parse(DateFormat('HH').format(_dateTime));
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 10;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'C800Regular',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: hourForTheme >= 18 || hourForTheme < 6
              ? colors[_Element.backgroundNight]
              : colors[_Element.backgroundDay],
              fit: BoxFit.cover)),
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: CustomPaint(
                  painter: DrawSun(-((_dateTime.hour-6) * radiansPerHour +
                      (_dateTime.minute / 60) * radiansPerHour)),
                  child: Container(),
                ),
              ),
              Positioned(
                child: CustomPaint(
                  painter: DrawMoon(-((_dateTime.hour+6) * radiansPerHour +
                      (_dateTime.minute / 60) * radiansPerHour)),
                  child: Container(),
                ),
              ),
              Positioned(
                child: Container(
                  child: Container(),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: hourForTheme >= 18 || hourForTheme < 6
                              ? colors[_Element.frontMountainNight]
                              : colors[_Element.frontMountainDay],
                          fit: BoxFit.fill)),
                ),
              ),
              Positioned(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container()),

              Align(alignment: Alignment.bottomCenter, child: Text(hour+":"+minute)),
            ],
          ),
        ),
      ),
    );
  }
}
