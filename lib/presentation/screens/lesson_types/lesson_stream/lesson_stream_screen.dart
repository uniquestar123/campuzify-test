import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/lesson_stream/lesson_stream_bloc.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/widgets/lesson_bottom_widget.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/questions_tab/questions_tab_screen.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/presentation/widgets/warning_lesson_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonStreamScreenArgs {
  LessonStreamScreenArgs(
    this.courseId,
    this.lessonId,
    this.authorAva,
    this.authorName,
  );

  final int courseId;
  final int lessonId;
  final String authorAva;
  final String authorName;
}

class LessonStreamScreen extends StatelessWidget {
  static const String routeName = '/lessonStreamScreen';

  @override
  Widget build(BuildContext context) {
    final LessonStreamScreenArgs args = ModalRoute.of(context)?.settings.arguments as LessonStreamScreenArgs;

    return BlocProvider(
      create: (context) => LessonStreamBloc(),
      child: _LessonStreamScreenWidget(
        args.courseId,
        args.lessonId,
        args.authorAva,
        args.authorName,
      ),
    );
  }
}

class _LessonStreamScreenWidget extends StatefulWidget {
  const _LessonStreamScreenWidget(this.courseId, this.lessonId, this.authorAva, this.authorName);

  final int courseId;
  final int lessonId;
  final String authorAva;
  final String authorName;

  @override
  State<StatefulWidget> createState() => _LessonStreamScreenState();
}

class _LessonStreamScreenState extends State<_LessonStreamScreenWidget> {
  late YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    BlocProvider.of<LessonStreamBloc>(context).add(FetchEvent(widget.courseId, widget.lessonId));
    super.initState();
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LessonStreamBloc, LessonStreamState>(
      listener: (BuildContext context, state) {
        if (state is CacheWarningLessonStreamState) {
          showDialog(context: context, builder: (context) => WarningLessonDialog());
        }
      },
      child: BlocBuilder<LessonStreamBloc, LessonStreamState>(
        builder: (context, state) {
          String? lessonNumber;
          String? lessonLabel;

          if (state is LoadedLessonStreamState) {
            lessonNumber = state.lessonResponse.section?.number;
            lessonLabel = state.lessonResponse.section?.label;
          }

          return Scaffold(
            backgroundColor: Color(0xFF151A25),
            appBar: AppBar(
              backgroundColor: Color(0xFF273044),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    lessonNumber ?? '',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                  Text(
                    lessonLabel ?? '',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  )
                ],
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 15.0),
                  child: SizedBox(
                    width: 42,
                    height: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        padding: EdgeInsets.all(0.0),
                        backgroundColor: Color(0xFFFFFFFF).withOpacity(0.1),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          QuestionsScreen.routeName,
                          arguments: QuestionsScreenArgs(widget.lessonId, 1),
                        );
                      },
                      child: SvgPicture.asset(
                        IconPath.faq,
                        color: Color(0xFFFFFFFF),
                        width: 20.0,
                        height: 20.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: loadPlayer(state),
              ),
            ),
            bottomNavigationBar: state is LoadedLessonStreamState
                ? LessonBottomWidget(
                    lessonResponse: state.lessonResponse,
                    isTrial: false,
                    courseId: widget.courseId,
                    lessonId: widget.lessonId,
                    authorAva: widget.authorAva,
                    authorName: widget.authorName,
                    hasPreview: false,
                    trial: false,
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }

  loadPlayer(state) {
    if (state is LoadedLessonStreamState) {
      String? videoId = YoutubePlayer.convertUrlToId(state.lessonResponse.video!);
      if (videoId != '') {
        _youtubePlayerController = YoutubePlayerController(
          initialVideoId: videoId!,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            isLive: true,
          ),
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(
              child: YoutubePlayer(
                controller: _youtubePlayerController,
                showVideoProgressIndicator: true,
                actionsPadding: EdgeInsets.only(left: 16.0),
                liveUIColor: Colors.red,
                bottomActions: [
                  CurrentPosition(),
                  SizedBox(width: 10.0),
                  ProgressBar(isExpanded: true),
                  SizedBox(width: 10.0),
                  RemainingDuration(),
                  FullScreenButton(),
                ],
                onReady: () {},
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: MaterialButton(
                height: 50,
                color: Color(0xFFCC0000),
                onPressed: () => _launchURL(state.lessonResponse.video!),
                child: Text(
                  localizations.getLocalization('go_to_live_button'),
                  textScaleFactor: 1.0,
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          )
        ],
      );
    }

    return LoaderWidget();
  }

  _launchURL(String url) async {
    await launchUrl(Uri.parse(url));
  }
}
