import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/data/models/lesson/lesson_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/complete_lesson/complete_lesson_bloc.dart';
import 'package:masterstudy_app/presentation/screens/final/final_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/lesson_stream/lesson_stream_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/quiz_lesson/quiz_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/text_lesson/text_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/lesson_video_screen.dart';
import 'package:masterstudy_app/presentation/screens/user_course_locked/user_course_locked_screen.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';

class LessonBottomWidget<T> extends StatefulWidget {
  LessonBottomWidget({
    Key? key,
    required this.isTrial,
    required this.courseId,
    required this.lessonId,
    required this.authorAva,
    required this.authorName,
    required this.hasPreview,
    required this.trial,
    this.itemsId,
    required this.lessonResponse,
    this.bgColor,
  }) : super(key: key);

  final bool isTrial;
  final int courseId;
  final int lessonId;
  final String authorAva;
  final String authorName;
  final bool hasPreview;
  final bool trial;
  final dynamic itemsId;
  final LessonResponse lessonResponse;
  final Color? bgColor;

  @override
  State<LessonBottomWidget> createState() => _LessonBottomWidgetState();
}

class _LessonBottomWidgetState extends State<LessonBottomWidget> {
  bool isCompletedCheck = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isTrial) {
      return const SizedBox();
    }

    return BlocProvider(
      create: (context) => CompleteLessonBloc(),
      child: BlocListener<CompleteLessonBloc, CompleteLessonState>(
        listener: (context, state) {
          if (state is SuccessCompleteLessonState) {
            isCompletedCheck = true;
          }
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.bgColor ?? Color(0xFFFFFFFF),
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
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                if (widget.lessonResponse.prevLesson != null)
                  ActionLessonButton(
                    iconData: Icons.chevron_left,
                    onTap: () {
                      switch (widget.lessonResponse.prevLessonType) {
                        case 'video':
                          Navigator.of(context).pushReplacementNamed(
                            LessonVideoScreen.routeName,
                            arguments: LessonVideoScreenArgs(
                              widget.courseId,
                              widget.lessonResponse.prevLesson!,
                              widget.authorAva,
                              widget.authorName,
                              widget.hasPreview,
                              widget.isTrial,
                            ),
                          );
                          break;
                        case 'quiz':
                          Navigator.of(context).pushReplacementNamed(
                            QuizLessonScreen.routeName,
                            arguments: QuizLessonScreenArgs(
                              widget.courseId,
                              widget.lessonResponse.prevLesson!,
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
                              widget.lessonResponse.prevLesson!,
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
                              widget.lessonResponse.prevLesson!,
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
                              widget.lessonResponse.prevLesson!,
                              widget.authorAva,
                              widget.authorName,
                              widget.hasPreview,
                              widget.trial,
                            ),
                          );
                      }
                    },
                  ),
                BlocBuilder<CompleteLessonBloc, CompleteLessonState>(
                  builder: (context, state) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: MaterialButton(
                          height: kButtonHeight,
                          color: ColorApp.mainColor,
                          /* onPressed: () async {
                var connectivityResult = await (Connectivity().checkConnectivity());

                // If user connect to mobile or wifi
                if (connectivityResult == ConnectivityResult.wifi ||
                    connectivityResult == ConnectivityResult.mobile) {
                  if (!state.lessonResponse.completed) {
                    BlocProvider.of<TextLessonBloc>(context).add(CompleteLessonEvent(courseId, lessonId));
                  }
                } else {
                  if (preferences.getString(PreferencesName.textLessonComplete) != null) {
                    var existRecord = jsonDecode(preferences.getString(PreferencesName.textLessonComplete)!);

                    for (var el in existRecord) {
                      if (el.toString().contains('added') && el['lesson_id'] == widget.lessonId) {
                        logger.i('Exist');
                      } else {
                        recordMap.add({
                          'course_id': widget.courseId,
                          'lesson_id': widget.lessonId,
                          'added': 1,
                        });

                        preferences.setString(PreferencesName.textLessonComplete, jsonEncode(recordMap));

                        setState(() {
                          completed = true;
                        });
                      }
                    }
                  } else {
                    recordMap.add({
                      'course_id': widget.courseId,
                      'lesson_id': widget.lessonId,
                      'added': 1,
                    });

                    preferences.setString(PreferencesName.textLessonComplete, jsonEncode(recordMap));
                    setState(() {
                      completed = true;
                    });
                  }
                }
              },*/
                          onPressed: state is LoadingCompleteLessonState
                              ? () {}
                              : () {
                                  if (!widget.lessonResponse.completed && !isCompletedCheck) {
                                    BlocProvider.of<CompleteLessonBloc>(context).add(
                                      UpdateLessonEvent(
                                        courseId: widget.courseId,
                                        lessonId: widget.lessonId,
                                      ),
                                    );
                                  }
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                widget.lessonResponse.completed || isCompletedCheck
                                    ? Icons.check_circle
                                    : Icons.panorama_fish_eye,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  localizations.getLocalization('complete_lesson_button'),
                                  textScaleFactor: 1.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ActionLessonButton(
                  iconData: Icons.chevron_right,
                  onTap: () {
                    if (widget.lessonResponse.nextLesson != null) {
                      if (widget.lessonResponse.nextLessonAvailable) {
                        switch (widget.lessonResponse.nextLessonType) {
                          case 'video':
                            Navigator.of(context).pushReplacementNamed(
                              LessonVideoScreen.routeName,
                              arguments: LessonVideoScreenArgs(
                                widget.courseId,
                                widget.lessonResponse.nextLesson!,
                                widget.authorAva,
                                widget.authorName,
                                widget.hasPreview,
                                widget.trial,
                              ),
                            );
                            break;
                          case 'quiz':
                            Navigator.of(context).pushReplacementNamed(
                              QuizLessonScreen.routeName,
                              arguments: QuizLessonScreenArgs(
                                widget.courseId,
                                widget.lessonResponse.nextLesson!,
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
                                widget.lessonResponse.nextLesson!,
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
                                widget.lessonResponse.nextLesson!,
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
                                widget.lessonResponse.nextLesson!,
                                widget.authorAva,
                                widget.authorName,
                                widget.hasPreview,
                                widget.trial,
                              ),
                            );
                        }
                      } else {
                        Navigator.of(context).pushNamed(
                          UserCourseLockedScreen.routeName,
                          arguments: UserCourseLockedScreenArgs(widget.courseId),
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
        ),
      ),
    );
  }
}

class ActionLessonButton extends StatelessWidget {
  const ActionLessonButton({Key? key, required this.onTap, required this.iconData}) : super(key: key);

  final VoidCallback onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      height: 35,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: ColorApp.mainColor),
          ),
          padding: EdgeInsets.all(0.0),
          backgroundColor: ColorApp.mainColor,
        ),
        onPressed: onTap,
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}
