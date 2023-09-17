import 'package:flutter/material.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class VimeoPlayerWidget extends StatelessWidget {
  const VimeoPlayerWidget({Key? key, required this.videoLink}) : super(key: key);

  final String videoLink;

  @override
  Widget build(BuildContext context) {
    return VimeoVideoPlayer(
      url: videoLink,
    );
  }
}
