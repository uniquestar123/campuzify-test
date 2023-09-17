import 'package:flutter/material.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class MetaIcon extends StatelessWidget {
  const MetaIcon(this.tag) : super();

  final String tag;

  @override
  Widget build(BuildContext context) {
    String? assetName;

    switch (tag) {
      case 'current_students':
        assetName = IconPath.enrolled;
        break;
      case 'duration':
        assetName = IconPath.duration;
        break;
      case 'curriculum':
        assetName = IconPath.lectures;
        break;
      case 'video_duration':
        assetName = IconPath.videoCurriculum;
        break;
      case 'level':
        assetName = IconPath.level;
        break;
    }

    return Image.asset(
      assetName!,
      width: 24,
      height: 24,
      color: ColorApp.mainColor,
    );
  }
}
