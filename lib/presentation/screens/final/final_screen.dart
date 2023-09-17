import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/final_response/final_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/final/final_bloc.dart';
import 'package:masterstudy_app/presentation/screens/final/widgets/result_item_widget.dart';
import 'package:masterstudy_app/presentation/screens/review_write/review_write_screen.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/presentation/widgets/warning_lesson_dialog.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

class FinalScreenArgs {
  FinalScreenArgs(this.courseId);

  final int courseId;
}

class FinalScreen extends StatelessWidget {
  const FinalScreen() : super();

  static const String routeName = '/finalScreen';

  @override
  Widget build(BuildContext context) {
    final FinalScreenArgs args = ModalRoute.of(context)?.settings.arguments as FinalScreenArgs;

    return BlocProvider(
      create: (context) => FinalBloc()..add(LoadFinalEvent(args.courseId)),
      child: _FinalScreenWidget(args.courseId),
    );
  }
}

class _FinalScreenWidget extends StatefulWidget {
  const _FinalScreenWidget(this.course_id);

  final int course_id;

  @override
  State<StatefulWidget> createState() => _FinalScreenState();
}

class _FinalScreenState extends State<_FinalScreenWidget> {
  late double width;
  late double progressWrapWidth;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    progressWrapWidth = (width - 60.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF273044),
        title: Text(
          localizations.getLocalization('final_page'),
          textScaleFactor: 1.0,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
      body: BlocListener<FinalBloc, FinalState>(
        listener: (BuildContext context, state) {
          if (state is CacheWarningState) {
            showDialog(
              context: context,
              builder: (context) => WarningLessonDialog(),
            );
          }
        },
        child: BlocBuilder<FinalBloc, FinalState>(
          builder: (context, state) {
            if (state is LoadingFinalState) {
              return LoaderWidget(
                loaderColor: ColorApp.mainColor,
              );
            }

            if (state is LoadedFinalState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          state.finalResponse.courseCompleted
                              ? localizations.getLocalization('success_completed_course')
                              : localizations.getLocalization('not_completed_course'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xFF2A3045),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: Text(
                          '${state.finalResponse.title}!',
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2A3045),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: Container(
                                width: progressWrapWidth,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFEEF1F7), width: 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: (width - 62.0) * (state.finalResponse.course!.progressPercent / 100),
                                      height: 74.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFEEF1F7),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            _buildProgressTitle(
                              state,
                              state.finalResponse.course!.progressPercent,
                            )
                          ],
                        ),
                      ),
                      state.finalResponse.courseCompleted
                          ? const SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              child: Text(
                                localizations.getLocalization('course_result_error'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Color(0xFF2A3045),
                                ),
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 20.0,
                          children: <Widget>[
                            if (state.finalResponse.curriculum?.lesson != null)
                              ResultItemWidget(
                                width: width,
                                iconData: IconPath.finalPages,
                                color: Color(0xFF2476F5),
                                title: localizations.getLocalization('pages'),
                                value:
                                    '${state.finalResponse.curriculum?.lesson?.completed}/${state.finalResponse.curriculum?.lesson?.total}',
                              ),
                            if (state.finalResponse.curriculum?.multimedia != null)
                              ResultItemWidget(
                                width: width,
                                iconData: IconPath.finalVideo,
                                color: Color(0xFFF61B40),
                                title: localizations.getLocalization('video'),
                                value:
                                    '${state.finalResponse.curriculum?.multimedia?.completed}/${state.finalResponse.curriculum?.multimedia?.total} hrs',
                              ),
                            if (state.finalResponse.curriculum?.assignment != null)
                              ResultItemWidget(
                                width: width,
                                iconData: IconPath.assignments,
                                color: Color(0xFFE9B356),
                                title: localizations.getLocalization('assignment'),
                                value:
                                    '${state.finalResponse.curriculum?.assignment?.completed}/${state.finalResponse.curriculum?.assignment?.total}',
                              ),
                            if (state.finalResponse.curriculum?.quiz != null)
                              ResultItemWidget(
                                width: width,
                                iconData: IconPath.finalQuizes,
                                color: Color(0xFF13C79B),
                                title: localizations.getLocalization('quizzes'),
                                value:
                                    '${state.finalResponse.curriculum?.quiz?.completed}/${state.finalResponse.curriculum?.quiz?.total}',
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                        child: _buildButtons(state.finalResponse),
                      )
                    ],
                  ),
                ),
              );
            }

            return ErrorCustomWidget(
              onTap: () => BlocProvider.of<FinalBloc>(context).add(
                LoadFinalEvent(widget.course_id),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildProgressTitle(LoadedFinalState state, int percent) {
    if (state.finalResponse.courseCompleted) {
      return Container(
        width: progressWrapWidth,
        height: 96.0,
        child: Padding(
          padding: EdgeInsets.only(left: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                IconPath.finalBadge,
                width: 96.0,
                height: 96.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  percent.toString() + '%',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2A3045),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container(
      width: progressWrapWidth,
      height: 96.0,
      child: Center(
        child: Text(
          percent.toString() + '%',
          textScaleFactor: 1.0,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 45.0,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2A3045),
          ),
        ),
      ),
    );
  }

  _buildButtons(FinalResponse? finalResponse) {
    if (finalResponse!.courseCompleted) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              localizations.getLocalization('certificate_available'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 14.0,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: MaterialButton(
                height: 50,
                color: ColorApp.mainColor,
                onPressed: () => _downloadCertificate(finalResponse.certificateUrl),
                child: Text(
                  localizations.getLocalization('download_certificate'),
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: MaterialButton(
                height: 50,
                color: ColorApp.secondaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    ReviewWriteScreen.routeName,
                    arguments: ReviewWriteScreenArgs(
                      finalResponse.course!.courseId!,
                      finalResponse.title!,
                    ),
                  );
                },
                child: Text(
                  localizations.getLocalization('leave_review'),
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: ColorApp.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: MaterialButton(
            height: 50,
            color: ColorApp.mainColor,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              localizations.getLocalization('go_to_curriculum'),
              style: TextStyle(fontSize: 14.0),
            ),
          ),
        ),
      );
    }
  }

  void _downloadCertificate(String? downloadUrl) async {
    String? apiToken = preferences.getString(PreferencesName.apiToken);
    if (apiToken != null) {
      await launchUrl(
        Uri.parse(downloadUrl!),
        webViewConfiguration: WebViewConfiguration(
          headers: <String, String>{'token': apiToken},
        ),
      );
    }
  }
}
