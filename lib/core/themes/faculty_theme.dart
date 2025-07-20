
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/core/constants/faculty_constants.dart';

final facultyTheme = ThemeData(
  primaryColor: facultyPrimary,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: facultyPrimary,
    secondary: facultySecondary,
    onSecondary: Colors.white,
  ),
  scaffoldBackgroundColor: facultyNavBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: facultyNavBackground,
    elevation: 0,
    iconTheme: IconThemeData(color: facultyPrimary),
  ),
  textTheme: TextTheme(
    headlineLarge: facultyHeadlineLarge,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: facultyPrimary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
);
