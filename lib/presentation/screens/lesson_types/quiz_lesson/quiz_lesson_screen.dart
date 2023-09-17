import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/quiz_lesson/quiz_lesson_bloc.dart';
import 'package:masterstudy_app/presentation/screens/final/final_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/lesson_stream/lesson_stream_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/quiz_lesson/widgets/quiz_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/text_lesson/text_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/lesson_video_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/widgets/lesson_bottom_widget.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/questions_tab/questions_tab_screen.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/presentation/widgets/warning_lesson_dialog.dart';
import 'package:masterstudy_app/presentation/widgets/webview_widgets/web_view_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class QuizLessonScreenArgs {
  QuizLessonScreenArgs(
    this.courseId,
    this.lessonId,
    this.authorAva,
    this.authorName,
  );

  final int lessonId;
  final int courseId;
  final String authorAva;
  final String authorName;
}

class QuizLessonScreen extends StatelessWidget {
  const QuizLessonScreen() : super();

  static const String routeName = '/quizLessonScreen';

  @override
  Widget build(BuildContext context) {
    QuizLessonScreenArgs args = ModalRoute.of(context)?.settings.arguments as QuizLessonScreenArgs;
    return BlocProvider(
      create: (context) => QuizLessonBloc(),
      child: QuizLessonWidget(
        args.courseId,
        args.lessonId,
        args.authorAva,
        args.authorName,
      ),
    );
  }
}

class QuizLessonWidget extends StatefulWidget {
  const QuizLessonWidget(this.courseId, this.lessonId, this.authorAva, this.authorName) : super();
  final int lessonId;
  final int courseId;
  final String authorAva;
  final String authorName;

  @override
  State<StatefulWidget> createState() => QuizLessonWidgetState();
}

class QuizLessonWidgetState extends State<QuizLessonWidget> {
  bool completed = false;

  @override
  void initState() {
    BlocProvider.of<QuizLessonBloc>(context).add(LoadQuizLessonEvent(widget.courseId, widget.lessonId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizLessonBloc, QuizLessonState>(
      listener: (BuildContext context, state) {
        if (state is CacheWarningQuizLessonState) {
          showDialog(context: context, builder: (context) => WarningLessonDialog());
        }
      },
      child: BlocBuilder<QuizLessonBloc, QuizLessonState>(
        builder: (BuildContext context, QuizLessonState state) {
          String? lessonNumber;
          String? lessonLabel;

          if (state is LoadedQuizLessonState) {
            lessonNumber = state.quizResponse.section?.number;
            lessonLabel = state.quizResponse.section?.label;
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF273044),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
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
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                        backgroundColor: MaterialStateProperty.all(Color(0xFF3E4555)),
                      ),
                      onPressed: () => Navigator.of(context).pushNamed(
                        QuestionsScreen.routeName,
                        arguments: QuestionsScreenArgs(widget.lessonId, 1),
                      ),
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
                ],
              ),
            ),
            body: Builder(
              builder: (context) {
                if (state is InitialQuizLessonState) {
                  return LoaderWidget(
                    loaderColor: ColorApp.mainColor,
                  );
                }

                if (state is LoadedQuizLessonState) {
                  return WebViewBaseWidget(
                    url: state.quizResponse.content,
                    onPageFinished: (Object data) {},
                  );
                }

                return ErrorCustomWidget(
                  onTap: () => BlocProvider.of<QuizLessonBloc>(context).add(
                    LoadQuizLessonEvent(widget.courseId, widget.lessonId),
                  ),
                );
              },
            ),
            bottomNavigationBar: state is LoadedQuizLessonState
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorApp.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withOpacity(.1),
                          offset: Offset(0, 0),
                          blurRadius: 6,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //Button back
                          if (state.quizResponse.prevLesson != null)
                            ActionLessonButton(
                              iconData: Icons.chevron_left,
                              onTap: () {
                                switch (state.quizResponse.prevLessonType) {
                                  case 'video':
                                    Navigator.of(context).pushReplacementNamed(
                                      LessonVideoScreen.routeName,
                                      arguments: LessonVideoScreenArgs(
                                        widget.courseId,
                                        state.quizResponse.prevLesson!,
                                        widget.authorAva,
                                        widget.authorName,
                                        false,
                                        true,
                                      ),
                                    );
                                    break;
                                  case 'quiz':
                                    Navigator.of(context).pushReplacementNamed(
                                      QuizLessonScreen.routeName,
                                      arguments: QuizLessonScreenArgs(
                                        widget.courseId,
                                        state.quizResponse.prevLesson!,
                                        widget.authorAva,
                                        widget.authorName,
                                      ),
                                    );
                                    break;
                                  case 'assignment':
                                    Navigator.of(context).pushReplacementNamed(
                                      AssignmentScreen.routeName,
                                      arguments: AssignmentScreenArgs(
                                        widget.courseId,
                                        state.quizResponse.prevLesson!,
                                        widget.authorAva,
                                        widget.authorName,
                                      ),
                                    );
                                    break;
                                  case 'stream':
                                    Navigator.of(context).pushReplacementNamed(
                                      LessonStreamScreen.routeName,
                                      arguments: LessonStreamScreenArgs(
                                        widget.courseId,
                                        state.quizResponse.prevLesson!,
                                        widget.authorAva,
                                        widget.authorName,
                                      ),
                                    );
                                    break;
                                  default:
                                    Navigator.of(context).pushReplacementNamed(
                                      TextLessonScreen.routeName,
                                      arguments: TextLessonScreenArgs(
                                        widget.courseId,
                                        state.quizResponse.prevLesson!,
                                        widget.authorAva,
                                        widget.authorName,
                                        false,
                                        true,
                                      ),
                                    );
                                }
                              },
                            )
                          else
                            const SizedBox(),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: MaterialButton(
                                height: 50,
                                color: ColorApp.mainColor,
                                onPressed: () async {
                                  Navigator.of(context).pushNamed(
                                    QuizScreen.routeName,
                                    arguments: QuizScreenArgs(
                                      state.quizResponse,
                                      widget.lessonId,
                                      widget.courseId,
                                    ),
                                  );
                                },
                                child: Text(
                                  localizations.getLocalization('start_quiz'),
                                  textScaleFactor: 1.0,
                                ),
                              ),
                            ),
                          ),
                          ActionLessonButton(
                            iconData: Icons.chevron_right,
                            onTap: () {
                              if (state.quizResponse.nextLesson != null) {
                                switch (state.quizResponse.nextLessonType) {
                                  case 'video':
                                    Navigator.of(context).pushReplacementNamed(
                                      LessonVideoScreen.routeName,
                                      arguments: LessonVideoScreenArgs(
                                        widget.courseId,
                                        state.quizResponse.nextLesson!,
                                        widget.authorAva,
                                        widget.authorName,
                                        false,
                                        true,
                                      ),
                                    );
                                    break;
                                  case 'quiz':
                                    Navigator.of(context).pushReplacementNamed(
                                      QuizLessonScreen.routeName,
                                      arguments: QuizLessonScreenArgs(
                                        widget.courseId,
                                        state.quizResponse.nextLesson!,
                                        widget.authorAva,
                                        widget.authorName,
                                      ),
                                    );
                                    break;
                                  case 'assignment':
                                    Navigator.of(context).pushReplacementNamed(
                                      AssignmentScreen.routeName,
                                      arguments: AssignmentScreenArgs(
                                        widget.courseId,
                                        state.quizResponse.nextLesson!,
                                        widget.authorAva,
                                        widget.authorName,
                                      ),
                                    );
                                    break;
                                  case 'stream':
                                    Navigator.of(context).pushReplacementNamed(
                                      LessonStreamScreen.routeName,
                                      arguments: LessonStreamScreenArgs(
                                        widget.courseId,
                                        state.quizResponse.nextLesson!,
                                        widget.authorAva,
                                        widget.authorName,
                                      ),
                                    );
                                    break;
                                  default:
                                    Navigator.of(context).pushReplacementNamed(
                                      TextLessonScreen.routeName,
                                      arguments: TextLessonScreenArgs(
                                        widget.courseId,
                                        state.quizResponse.nextLesson!,
                                        widget.authorAva,
                                        widget.authorName,
                                        false,
                                        true,
                                      ),
                                    );
                                }
                              } else {
                                var future = Navigator.of(context).pushNamed(
                                  FinalScreen.routeName,
                                  arguments: FinalScreenArgs(widget.courseId),
                                );
                                future.then((value) {
                                  Navigator.pop(context);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
