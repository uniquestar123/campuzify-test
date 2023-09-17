import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/text_lesson/text_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/lesson_video_screen.dart';
import 'package:masterstudy_app/presentation/widgets/alert_dialogs.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class CurriculumWidget extends StatefulWidget {
  CurriculumWidget(this.courseDetailResponse, this.optionsBean) : super();

  final CourseDetailResponse courseDetailResponse;
  final OptionsBean? optionsBean;

  @override
  _CurriculumWidgetState createState() => _CurriculumWidgetState();
}

class _CurriculumWidgetState extends State<CurriculumWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.courseDetailResponse.curriculum!.isEmpty) {
      return EmptyWidget(
        iconData: IconPath.emptyCourses,
        title: localizations.getLocalization('lesson_havent_curriculum'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: widget.courseDetailResponse.curriculum!.length,
      itemBuilder: (context, index) {
        var curriculumBean = widget.courseDetailResponse.curriculum![index];
        if (curriculumBean!.type == 'section') {
          return _buildSection(curriculumBean);
        } else if (curriculumBean.type == 'lesson') {
          return _buildLesson(context, curriculumBean);
        } else if (curriculumBean.type == 'quiz') {
          return _buildQuiz(curriculumBean);
        }
        return Center();
      },
    );
  }

  Widget _buildSection(CurriculumBean curriculumBean) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            curriculumBean.view ?? '',
            textScaleFactor: 1.0,
            style: TextStyle(color: Color(0xFFAAAAAA)),
          ),
          Text(
            curriculumBean.label ?? '',
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Color(0xFF273044),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildLesson(BuildContext context, CurriculumBean curriculumBean) {
    Widget icon = const SizedBox();

    switch (curriculumBean.view) {
      case 'video':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.play,
            color: (curriculumBean.hasPreview) ? ColorApp.mainColor : Color(0xF2A3045).withOpacity(0.3),
          ),
        );
        break;
      case 'assignment':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.assignment,
            color: (curriculumBean.hasPreview) ? ColorApp.mainColor : Color(0xFF2A3045).withOpacity(0.3),
          ),
        );
        break;
      case 'slide':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.slides,
            color: (curriculumBean.hasPreview) ? ColorApp.mainColor : Color(0xFF2A3045).withOpacity(0.3),
          ),
        );
        break;
      case 'stream':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.videoCamera,
            color: (curriculumBean.hasPreview) ? ColorApp.mainColor : Color(0xFF2A3045).withOpacity(0.3),
          ),
        );
        break;
      case 'quiz':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.question,
            color: (curriculumBean.hasPreview) ? ColorApp.mainColor : Color(0xFF2A3045).withOpacity(0.3),
          ),
        );
        break;
      case 'text':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.text,
            color: (curriculumBean.hasPreview) ? ColorApp.mainColor : Color(0xFF2A3045).withOpacity(0.3),
          ),
        );
        break;
      case '':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.text,
            color: (curriculumBean.hasPreview) ? ColorApp.mainColor : Color(0xFF2A3045).withOpacity(0.3),
          ),
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Color(0xFFF3F5F9)),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              icon,
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    curriculumBean.label!,
                    textScaleFactor: 1.0,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ),
              (curriculumBean.hasPreview || widget.courseDetailResponse.trial)
                  ? Container(
                      constraints: BoxConstraints(minWidth: 110, maxWidth: 110),
                      height: 36,
                      child: MaterialButton(
                        height: 36,
                        minWidth: 110,
                        padding: EdgeInsets.only(left: 0, right: 0),
                        color: ColorApp.secondaryColor,
                        onPressed: () async {
                          if (await isAuth() == false) {
                            showNotAuthorizedDialog(
                              context,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AuthScreen.routeName,
                                  arguments: AuthScreenArgs(
                                    optionsBean: widget.optionsBean,
                                  ),
                                );
                              },
                            );
                          } else {
                            switch (curriculumBean.view) {
                              case 'video':
                                Navigator.of(context).pushNamed(
                                  LessonVideoScreen.routeName,
                                  arguments: LessonVideoScreenArgs(
                                    widget.courseDetailResponse.id,
                                    curriculumBean.lessonId!,
                                    widget.courseDetailResponse.author!.avatarUrl!,
                                    widget.courseDetailResponse.author!.login,
                                    curriculumBean.hasPreview,
                                    false,
                                  ),
                                );
                                break;
                              default:
                                Navigator.of(context).pushNamed(
                                  TextLessonScreen.routeName,
                                  arguments: TextLessonScreenArgs(
                                    widget.courseDetailResponse.id,
                                    curriculumBean.lessonId!,
                                    widget.courseDetailResponse.author!.avatarUrl!,
                                    widget.courseDetailResponse.author!.login,
                                    curriculumBean.hasPreview,
                                    false,
                                  ),
                                );
                            }
                          }
                        },
                        child: Text(
                          localizations.getLocalization('preview_button'),
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  _buildQuiz(CurriculumBean curriculumBean) {
    Widget icon = SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        IconPath.question,
        color: (curriculumBean.hasPreview) ? ColorApp.mainColor : Color(0xFF2A3045).withOpacity(0.3),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Color(0xFFF3F5F9)),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16, left: 20, right: 20),
          child: Row(
            children: <Widget>[
              icon,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    curriculumBean.label ?? '',
                    textScaleFactor: 1.0,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
