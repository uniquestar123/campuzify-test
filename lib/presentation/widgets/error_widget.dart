import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';

class ErrorCustomWidget extends StatelessWidget {
  const ErrorCustomWidget({required this.onTap, this.message});

  final VoidCallback onTap;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              IconPath.errorIcon,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 10.0),
            RichText(
              textAlign: TextAlign.center,
              textScaleFactor: 1.0,
              text: TextSpan(
                text: message ?? localizations.getLocalization('network_error'),
                style: TextStyle(
                  color: Color(0xffD7DAE2),
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                height: kButtonHeight,
                color: ColorApp.mainColor,
                onPressed: onTap,
                child: Text(
                  localizations.getLocalization('error_button'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
