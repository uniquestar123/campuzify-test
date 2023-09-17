import 'package:flutter/material.dart';
import 'package:masterstudy_app/core/extensions/color_extensions.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';

class ColorApp {
  static Color mainColor = Color(0xFF195ec8);
  static Color secondaryColor = Color(0xFF17d292);
  static const bgColor = Color(0xFFffffff);
  static const bgColorGrey = Color(0xFFF3F5F9);
  static const Color redColor = Color(0xFFFF3B30);
  static const Color lipstick = Color(0xFFd7143a);
  static const Color dark = Color(0xFF2a3045);
  static const Color white = Color(0xFFf6f6f6);
  static const Color kDarkGray = Color(0xFFAAAAAA);
  static const Color kDividerColor = Color(0xFFE5E5E5);


  // BottomNavigationBar Color
  static Color unselectedColor = Colors.grey;

  void setMainColorRGB(ColorBean colorBean) {
    mainColor = Color.fromRGBO(
      colorBean.r.toInt(),
      colorBean.g.toInt(),
      colorBean.b.toInt(),
      0.999,
    );
  }

  void setMainColorHex(String mainColorHex) {
    mainColor = HexColor.fromHex(mainColorHex);
  }

  void setSecondaryColorRGB(ColorBean colorBean) {
    secondaryColor = Color.fromRGBO(
      colorBean.r.toInt(),
      colorBean.g.toInt(),
      colorBean.b.toInt(),
      0.999,
    );
  }

  void setSecondaryColorHex(String secondaryColorHex) {
    secondaryColor = HexColor.fromHex(secondaryColorHex);
  }
}
