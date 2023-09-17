import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/assignment/assignment_bloc.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_state/assignment_draft.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_state/assignment_pass_unpass.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_state/assignment_pending.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_state/assignment_preview.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/lesson_stream/lesson_stream_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/quiz_lesson/quiz_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/text_lesson/text_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/lesson_video_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/widgets/lesson_bottom_widget.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/questions_tab/questions_tab_screen.dart';
import 'package:masterstudy_app/presentation/widgets/dialog_author.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';

class AssignmentScreenArgs {
  AssignmentScreenArgs(this.courseId, this.assignmentId, this.authorAva, this.authorName);

  final int courseId;
  final int assignmentId;
  final String authorAva;
  final String authorName;
}

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen() : super();

  static const String routeName = '/assignmentScreen';

  @override
  Widget build(BuildContext context) {
    final AssignmentScreenArgs args = ModalRoute.of(context)?.settings.arguments as AssignmentScreenArgs;

    return BlocProvider(
      create: (context) => AssignmentBloc()..add(LoadAssignmentEvent(args.courseId, args.assignmentId)),
      child: _AssignmentScreenWidget(
        args.courseId,
        args.assignmentId,
        args.authorAva,
        args.authorName,
      ),
    );
  }
}

class _AssignmentScreenWidget extends StatefulWidget {
  const _AssignmentScreenWidget(this.courseId, this.assignmentId, this.authorAva, this.authorName);

  final int courseId;
  final int assignmentId;
  final String authorAva;
  final String authorName;

  @override
  State<StatefulWidget> createState() => _AssignmentScreenWidgetState();
}

class _AssignmentScreenWidgetState extends State<_AssignmentScreenWidget> {
  final GlobalKey<AssignmentDraftWidgetState> assignmentDraftWidgetState = GlobalKey<AssignmentDraftWidgetState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignmentBloc, AssignmentState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF273044),
            title: Text(
              localizations.getLocalization('assignment_screen_title'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            actions: <Widget>[
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(60)),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    QuestionsScreen.routeName,
                    arguments: QuestionsScreenArgs(widget.assignmentId, 1),
                  );
                },
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
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Builder(
                      builder: (context) {
                        if (state is InitialAssignmentState) {
                          return LoaderWidget(
                            loaderColor: ColorApp.mainColor,
                          );
                        }

                        if (state is LoadedAssignmentState) {
                          switch (state.assignmentResponse.status) {
                            case 'new':
                              return AssignmentPreviewWidget(
                                state.assignmentResponse,
                                widget.courseId,
                                widget.assignmentId,
                              );
                            case 'unpassed':
                              return AssignmentPassUnpassWidget(
                                state.assignmentResponse,
                                widget.courseId,
                                widget.assignmentId,
                                widget.authorAva,
                                widget.authorName,
                              );
                            case 'passed':
                              return AssignmentPassUnpassWidget(
                                state.assignmentResponse,
                                widget.courseId,
                                widget.assignmentId,
                                widget.authorAva,
                                widget.authorName,
                              );
                            case 'draft':
                              return AssignmentDraftWidget(
                                assignmentDraftWidgetState,
                                state.assignmentResponse,
                                widget.courseId,
                                widget.assignmentId,
                                state.assignmentResponse.draftId,
                              );
                            case 'pending':
                              return AssignmentPendingWidget(
                                state.assignmentResponse,
                              );
                            default:
                              return const SizedBox();
                          }
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ),
              if (state is LoadingStartAssignmentState || state is LoadingAddAssignmentState)
                ColoredBox(
                  color: Colors.transparent.withOpacity(0.05),
                  child: LoaderWidget(),
                )
              else
                const SizedBox(),
            ],
          ),
          bottomNavigationBar: _buildBottomWidget(state),
        );
      },
    );
  }

  _buildBottomWidget(AssignmentState state) {
    if (state is InitialAssignmentState) {
      return const SizedBox();
    }

    if (state is LoadedAssignmentState) {
      switch (state.assignmentResponse.status) {
        case 'new':
          return _buildBottomStatusNew(state);
        case 'draft':
          return _buildBottomStatusDraft(state);
        default:
          return SizedBox();
      }
    }
  }

  _buildBottomStatusNew(LoadedAssignmentState state) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (state.assignmentResponse.prevLesson != '')
              ActionLessonButton(
                iconData: Icons.chevron_left,
                onTap: () {
                  switch (state.assignmentResponse.prevLessonType) {
                    case 'video':
                      Navigator.of(context).pushReplacementNamed(
                        LessonVideoScreen.routeName,
                        arguments: LessonVideoScreenArgs(
                          widget.courseId,
                          int.tryParse(state.assignmentResponse.prevLesson)!,
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
                          int.tryParse(state.assignmentResponse.prevLesson)!,
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
                          int.tryParse(state.assignmentResponse.prevLesson)!,
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
                          int.tryParse(state.assignmentResponse.prevLesson)!,
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
                          int.tryParse(state.assignmentResponse.prevLesson)!,
                          widget.authorAva,
                          widget.authorName,
                          false,
                          true,
                        ),
                      );
                  }
                },
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: kButtonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorApp.mainColor,
                    ),
                    onPressed: state is LoadingStartAssignmentState
                        ? null
                        : () {
                            if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                              showDialogError(context, localizations.getLocalization('demo_mode'));
                            } else {
                              BlocProvider.of<AssignmentBloc>(context)
                                  .add(StartAssignmentEvent(widget.courseId, widget.assignmentId));
                            }
                          },
                    child: state is LoadingStartAssignmentState
                        ? LoaderWidget()
                        : Text(
                            state.assignmentResponse.button?.toUpperCase() ?? '',
                          ),
                  ),
                ),
              ),
            ),
            if (state.assignmentResponse.nextLesson != '')
              ActionLessonButton(
                iconData: Icons.chevron_right,
                onTap: () {
                  switch (state.assignmentResponse.nextLessonType) {
                    case 'video':
                      Navigator.of(context).pushReplacementNamed(
                        LessonVideoScreen.routeName,
                        arguments: LessonVideoScreenArgs(
                          widget.courseId,
                          int.tryParse(state.assignmentResponse.nextLesson)!,
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
                          int.tryParse(state.assignmentResponse.nextLesson)!,
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
                          int.tryParse(state.assignmentResponse.nextLesson)!,
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
                          int.tryParse(state.assignmentResponse.prevLesson)!,
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
                          int.tryParse(state.assignmentResponse.nextLesson)!,
                          widget.authorAva,
                          widget.authorName,
                          false,
                          true,
                        ),
                      );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  _buildBottomStatusDraft(LoadedAssignmentState state) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
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
        child: SizedBox(
          height: kButtonHeight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.mainColor,
            ),
            onPressed: state is LoadingAddAssignmentState
                ? null
                : () => assignmentDraftWidgetState.currentState?.addAssignment(),
            child: state is LoadingAddAssignmentState
                ? LoaderWidget()
                : Text(
                    localizations.getLocalization('assignment_send_button'),
                    textScaleFactor: 1.0,
                  ),
          ),
        ),
      ),
    );
  }
}
