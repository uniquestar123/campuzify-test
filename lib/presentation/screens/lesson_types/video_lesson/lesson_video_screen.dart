import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/lesson_video/lesson_video_bloc.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/widgets/video_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/widgets/lesson_bottom_widget.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/widgets/lesson_materials_widget.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/questions_tab/questions_tab_screen.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/presentation/widgets/webview_widgets/web_view_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';

class LessonVideoScreenArgs {
  LessonVideoScreenArgs(this.courseId, this.lessonId, this.authorAva, this.authorName, this.hasPreview, this.trial);

  final int courseId;
  final int lessonId;
  final String authorAva;
  final String authorName;
  final bool hasPreview;
  final bool trial;
}

class LessonVideoScreen extends StatelessWidget {
  const LessonVideoScreen() : super();

  static const String routeName = '/lessonVideoScreen';

  @override
  Widget build(BuildContext context) {
    final LessonVideoScreenArgs args = ModalRoute.of(context)?.settings.arguments as LessonVideoScreenArgs;

    return BlocProvider(
      create: (c) => LessonVideoBloc(),
      child: _LessonVideoScreenWidget(
        args.courseId,
        args.lessonId,
        args.authorAva,
        args.authorName,
        args.hasPreview,
        args.trial,
      ),
    );
  }
}

class _LessonVideoScreenWidget extends StatefulWidget {
  const _LessonVideoScreenWidget(
    this.courseId,
    this.lessonId,
    this.authorAva,
    this.authorName,
    this.hasPreview,
    this.trial,
  );

  final int courseId;
  final int lessonId;
  final String authorAva;
  final String authorName;
  final bool hasPreview;
  final bool trial;

  @override
  State<StatefulWidget> createState() => _LessonVideoScreenState();
}

class _LessonVideoScreenState extends State<_LessonVideoScreenWidget> {
  late VoidCallback listener;

  double? contentWebHeight = 300.0;

  @override
  void initState() {
    BlocProvider.of<LessonVideoBloc>(context).add(FetchEvent(widget.courseId, widget.lessonId));
    super.initState();
  }

  double progressWeb = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonVideoBloc, LessonVideoState>(
      builder: (context, state) {
        String? lessonNumber;
        String? lessonLabel;

        if (state is LoadedLessonVideoState) {
          lessonNumber = state.lessonResponse.section?.number;
          lessonLabel = state.lessonResponse.section?.label;
        }

        return Scaffold(
          backgroundColor: Color(0xFF151A25),
          appBar: AppBar(
            backgroundColor: Color(0xFF273044),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    lessonNumber ?? '',
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  Flexible(
                    child: Text(
                      lessonLabel ?? '',
                      textScaleFactor: 1.0,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              widget.hasPreview
                  ? const SizedBox()
                  : InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      onTap: () => Navigator.of(context).pushNamed(
                        QuestionsScreen.routeName,
                        arguments: QuestionsScreenArgs(widget.lessonId, 1),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Color(0xFF3E4555),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: SvgPicture.asset(
                              IconPath.questionIcon,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 10.0, right: 10, bottom: 20, left: 10),
            child: Builder(
              builder: (context) {
                if (state is InitialLessonVideoState) {
                  return LoaderWidget(
                    loaderColor: ColorApp.white,
                  );
                }

                if (state is LoadedLessonVideoState) {
                  var item = state.lessonResponse;

                  return SingleChildScrollView(
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text "Video $NUMBER"
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, right: 7.0, bottom: 10.0, left: 7.0),
                          child: Text(
                            '${localizations.getLocalization('video')} ${item.section?.index}',
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                        ),
                        // Title of Video Lesson
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                          child: Text(
                            '${item.title}',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                        // Video
                        if (item.video != null && item.video!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, right: 7.0, bottom: 0.0, left: 7.0),
                            child: Container(
                              height: 211.0,
                              child: Stack(
                                children: <Widget>[
                                  //Background Photo of Video
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 211.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(item.videoPoster!),
                                      ),
                                    ),
                                  ),
                                  // Button "Play Video"
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width / 2,
                                      height: kButtonHeight,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 10,
                                              spreadRadius: -2,
                                              offset: Offset(0, 12.0),
                                            )
                                          ],
                                        ),
                                        // Button "Play Video"
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                            ),
                                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                                            backgroundColor: MaterialStateProperty.all(Color(0xffD7143A)),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                              VideoScreen.routeName,
                                              arguments: VideoScreenArgs(
                                                item.title!,
                                                item.video!,
                                                item.videoType,
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(left: 0, right: 4.0),
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                localizations.getLocalization('play_video_button'),
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          const SizedBox(),

                        // WebView
                        if (state.lessonResponse.content != null && state.lessonResponse.content!.isNotEmpty)
                          SizedBox(
                            height: contentWebHeight,
                            child: WebViewBaseWidget(
                              url: state.lessonResponse.content,
                              onPageFinished: (Object data) {
                                setState(() {
                                  contentWebHeight = double.parse(data.toString());
                                });
                              },
                            ),
                          )
                        else
                          const SizedBox(),

                        LessonMaterialsWidget(
                          lessonResponse: state.lessonResponse,
                          darkMode: true,
                        ),
                      ],
                    ),
                  );
                }

                if (state is ErrorLessonVideoState) {
                  return ErrorCustomWidget(
                    message: state.message,
                    onTap: () => BlocProvider.of<LessonVideoBloc>(context).add(
                      FetchEvent(widget.courseId, widget.lessonId),
                    ),
                  );
                }

                return ErrorCustomWidget(
                  onTap: () => BlocProvider.of<LessonVideoBloc>(context).add(
                    FetchEvent(widget.courseId, widget.lessonId),
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: state is LoadedLessonVideoState
              ? LessonBottomWidget(
                  isTrial: widget.trial,
                  courseId: widget.courseId,
                  lessonId: widget.lessonId,
                  authorAva: widget.authorAva,
                  authorName: widget.authorName,
                  hasPreview: widget.hasPreview,
                  lessonResponse: state.lessonResponse,
                  trial: widget.trial,
                  bgColor: Color(0xFF273044),
                )
              : const SizedBox(),
        );
      },
    );
  }
}
