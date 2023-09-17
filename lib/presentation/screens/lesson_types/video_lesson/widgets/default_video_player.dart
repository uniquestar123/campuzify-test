import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class DefaultVideoPlayerWidget extends StatefulWidget {
  const DefaultVideoPlayerWidget({Key? key, required this.videoLink}) : super(key: key);

  final String videoLink;

  @override
  State<DefaultVideoPlayerWidget> createState() => _DefaultVideoPlayerWidgetState();
}

class _DefaultVideoPlayerWidgetState extends State<DefaultVideoPlayerWidget> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  double _aspectRatio = 16 / 9;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.contentUri(Uri.parse(widget.videoLink))
      ..initialize().then((_) {
        setState(() {
          _controller?.play();
        });
      });
    _chewieController = ChewieController(
      allowedScreenSleep: false,
      allowFullScreen: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      videoPlayerController: _controller!,
      aspectRatio: _aspectRatio,
      autoInitialize: true,
      autoPlay: true,
      showControls: true,
    );
    _chewieController?.addListener(() {
      if (_chewieController!.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Chewie(
        controller: _chewieController!,
      ),
    );
  }
}
