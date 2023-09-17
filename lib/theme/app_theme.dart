import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masterstudy_app/theme/app_color.dart';

/// All custom application theme
class AppTheme {
  // Default application theme
  final ThemeData _themeLight = ThemeData.light();

  ThemeData get themeLight => _themeLight.copyWith(
        primaryColor: ColorApp.mainColor,
        buttonTheme: buttonThemeData,
        buttonBarTheme: _themeLight.buttonBarTheme.copyWith(
          buttonTextTheme: ButtonTextTheme.accent,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        textTheme: getTextTheme(_themeLight.primaryTextTheme),
        primaryTextTheme: getTextTheme(_themeLight.primaryTextTheme).apply(
          bodyColor: ColorApp.mainColor,
          displayColor: ColorApp.mainColor,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ColorApp.mainColor).copyWith(
              error: Colors.red[400],
            ),
      );
}

TextTheme getTextTheme(TextTheme theme) {
  var baseTextColor = Colors.black;

  return theme.copyWith(
    displayLarge:
        GoogleFonts.roboto(fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5, color: baseTextColor),
    displayMedium:
        GoogleFonts.roboto(fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5, color: baseTextColor),
    displaySmall: GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400, color: baseTextColor),
    headlineMedium:
        GoogleFonts.roboto(fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: baseTextColor),
    headlineSmall: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400, color: baseTextColor),
    titleLarge: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w500, letterSpacing: 0.52, color: Colors.white),
    titleMedium:
        GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: baseTextColor),
    titleSmall: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: baseTextColor),
    bodyMedium: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: baseTextColor),
    bodyLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: baseTextColor),
    labelLarge:
        GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25, color: baseTextColor),
    bodySmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: baseTextColor),
    labelSmall: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5, color: baseTextColor),
  );
}

final ButtonThemeData buttonThemeData = ButtonThemeData(
  height: 50,
  buttonColor: Colors.blueAccent,
  textTheme: ButtonTextTheme.primary,
);
