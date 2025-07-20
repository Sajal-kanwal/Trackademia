
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/core/constants/hod_constants.dart';

final hodTheme = ThemeData(
  primaryColor: hodPrimary,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: hodPrimary,
    secondary: hodSecondary,
    onSecondary: Colors.white,
  ),
  scaffoldBackgroundColor: hodNavBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: hodNavBackground,
    elevation: 0,
    iconTheme: IconThemeData(color: hodPrimary),
  ),
  textTheme: TextTheme(
    headlineLarge: hodHeadlineLarge,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: hodPrimary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

    ),
  ),
);
