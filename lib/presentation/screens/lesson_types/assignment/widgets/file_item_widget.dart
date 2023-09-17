import 'package:flutter/material.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class FileItemWidget extends StatelessWidget {
  const FileItemWidget({
    super.key,
    required this.valueText,
    this.onDelete,
  });

  final String? valueText;

  /// Parameter is used when assignmentStatus == draft
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: ColoredBox(
          color: Color(0xFFEEF1F7),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.cloud_download,
                  color: ColorApp.mainColor,
                  size: 22.0,
                ),
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(valueText ?? ''),
                  ),
                ),
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.close,
                      size: 22.0,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
