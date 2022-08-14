import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';

Future<ThemeData> initThemeData() async {
  var themeStr = await rootBundle.loadString('assets/style.json');
  var themeJson = json.decode(themeStr);

  var theme = ThemeDecoder.decodeThemeData(themeJson) ?? ThemeData();
  return theme;
}
