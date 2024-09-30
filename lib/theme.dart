import 'package:flutter/material.dart';
import 'package:physio/colors.dart';

final appTheme = ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(bgPrimaryBlue),
          foregroundColor: WidgetStateProperty.all(Colors.white))),
);
