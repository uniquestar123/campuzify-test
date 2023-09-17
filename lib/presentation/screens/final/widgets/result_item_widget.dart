import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResultItemWidget extends StatelessWidget {
  const ResultItemWidget({
    super.key,
    required this.width,
    required this.iconData,
    required this.color,
    required this.title,
    required this.value,
  });

  final double width;

  /// Icon of lessons
  final String iconData;

  /// Color of lessons
  final Color color;

  /// Name of lesson
  final String title;

  /// Value of lesson results
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: width * 0.40,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFEEF1F7), width: 1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: SizedBox(
                  width: 35,
                  child: Center(
                    child: SvgPicture.asset(
                      iconData,
                      color: color,
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    title,
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    value,
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
