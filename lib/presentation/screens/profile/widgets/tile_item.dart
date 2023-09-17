import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class TileWidget extends StatelessWidget {
  const TileWidget({
    Key? key,
    required this.title,
    required this.assetPath,
    required this.onClick,
    this.textColor,
    this.iconColor,
  }) : super(key: key);

  final String title;
  final String assetPath;
  final VoidCallback onClick;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      assetPath,
      color: (iconColor == null) ? ColorApp.mainColor : iconColor,
    );
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: const EdgeInsets.only(left: 36.0, top: 15.0, bottom: 15.0),
          leading: SizedBox(
            child: svg,
            width: 23,
            height: 23,
          ),
          title: Text(
            title,
            textScaleFactor: 1.0,
            style: TextStyle(
              color: textColor == null ? ColorApp.dark : textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: onClick,
        ),
        Divider(
          height: 5.0,
          thickness: 1.0,
          color: ColorApp.kDividerColor,
        ),
      ],
    );
  }
}
