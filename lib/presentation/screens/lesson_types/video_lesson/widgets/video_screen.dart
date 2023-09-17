import 'package:flutter/material.dart';
import 'package:masterstudy_app/data/models/lesson/lesson_response.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/widgets/default_video_player.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/widgets/vimeo_player.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/widgets/youtube_player.dart';
import 'package:masterstudy_app/presentation/widgets/webview_widgets/in_app_webview_widget.dart';
import 'package:masterstudy_app/presentation/widgets/webview_widgets/web_view_widget.dart';

class VideoScreenArgs {
  VideoScreenArgs(
    this.title,
    this.videoLink,
    this.videoType,
  );

  final String title;
  final String videoLink;
  final VideoTypeCode videoType;
}

class VideoScreen extends StatelessWidget {
  const VideoScreen() : super();

  static const String routeName = '/videoScreen';

  @override
  Widget build(BuildContext context) {
    final VideoScreenArgs args = ModalRoute.of(context)!.settings.arguments as VideoScreenArgs;

    return _VideoScreenWidget(
      title: args.title,
      videoLink: args.videoLink,
      videoType: args.videoType,
    );
  }
}

class _VideoScreenWidget extends StatelessWidget {
  const _VideoScreenWidget({
    Key? key,
    required this.title,
    required this.videoLink,
    required this.videoType,
  }) : super(key: key);

  final String title;
  final String videoLink;
  final VideoTypeCode videoType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (videoType == VideoTypeCode.vimeo) {
            return VimeoPlayerWidget(videoLink: videoLink);
          }

          if (videoType == VideoTypeCode.youtube) {
            return YouTubePlayerWidget(videoLink: videoLink);
          }

          if (videoType == VideoTypeCode.html) {
            return DefaultVideoPlayerWidget(videoLink: videoLink);
          }

          if (videoType == VideoTypeCode.ext_link) {
            return WebViewBaseWidget(
              url: videoLink,
              isWebViewPage: true,
              onPageFinished: (Object data) {},
            );
          }

          if (videoType == VideoTypeCode.embed) {
            return InAppWebViewBaseWidget(
              url: videoLink,
            );
          }

          if (videoType == VideoTypeCode.shortcode) {
            return InAppWebViewBaseWidget(
              url: videoLink,
            );
          }

          return Text('Error');
        },
      ),
    );
  }
}
