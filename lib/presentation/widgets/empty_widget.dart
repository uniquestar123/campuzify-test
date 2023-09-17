import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
    required this.iconData,
    required this.title,
    this.buttonText,
    this.onTap,
  }) : super(key: key);

  final String iconData;
  final String title;
  final String? buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget? buildButton;

    if (buttonText != null && buttonText!.isNotEmpty) {
      buildButton = Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: MaterialButton(
            minWidth: double.infinity,
            color: ColorApp.secondaryColor,
            onPressed: onTap,
            child: Text(
              buttonText!,
              textScaleFactor: 1.0,
              textAlign: TextAlign.center,
            ),
            textColor: Colors.white,
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            iconData,
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 10.0),
          Text(
            title,
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Color(0xffD7DAE2),
              fontSize: 18,
            ),
          ),
          buildButton ?? const SizedBox(),
        ],
      ),
    );
  }
}
