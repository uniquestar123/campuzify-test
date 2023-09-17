import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/presentation/bloc/lesson_zoom/zoom_bloc.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/widgets/lesson_materials_widget.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/questions_tab/questions_tab_screen.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/presentation/widgets/webview_widgets/web_view_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class LessonZoomScreenArgs {
  LessonZoomScreenArgs(
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
}

class LessonZoomScreen extends StatelessWidget {
  const LessonZoomScreen() : super();
  static const String routeName = '/lessonZoomScreen';

  @override
  Widget build(BuildContext context) {
    final LessonZoomScreenArgs args = ModalRoute.of(context)?.settings.arguments as LessonZoomScreenArgs;

    return BlocProvider(
      create: (c) => LessonZoomBloc(),
      child: LessonZoomScreenWidget(
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

class LessonZoomScreenWidget extends StatefulWidget {
  const LessonZoomScreenWidget(
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
  State<LessonZoomScreenWidget> createState() => _LessonZoomScreenWidgetState();
}

class _LessonZoomScreenWidgetState extends State<LessonZoomScreenWidget> {
  double? contentWebHeight = 300.0;

  @override
  void initState() {
    BlocProvider.of<LessonZoomBloc>(context).add(FetchEvent(widget.courseId, widget.lessonId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonZoomBloc, LessonZoomState>(
      builder: (context, state) {
        String? lessonNumber;
        String? lessonLabel;

        if (state is LoadedLessonZoomState) {
          lessonNumber = state.lessonResponse.section?.number;
          lessonLabel = state.lessonResponse.section?.label;
        }

        return Scaffold(
          backgroundColor: Color(0xFF151A25),
          appBar: AppBar(
            backgroundColor: Color(0xFF273044),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //Title and Label Course
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        lessonNumber ?? '',
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                      Flexible(
                        child: Text(
                          lessonLabel ?? '',
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
                widget.hasPreview
                    ? const SizedBox()
                    : SizedBox(
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
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              QuestionsScreen.routeName,
                              arguments: QuestionsScreenArgs(widget.lessonId, 1),
                            );
                          },
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
          body: SingleChildScrollView(
            clipBehavior: Clip.hardEdge,
            child: Builder(
              builder: (context) {
                if (state is InitialLessonZoomState) {
                  return LoaderWidget(
                    loaderColor: ColorApp.mainColor,
                  );
                }

                if (state is LoadedLessonZoomState) {
                  var item = state.lessonResponse;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: contentWebHeight,
                        child: WebViewBaseWidget(
                          url: state.lessonResponse.content,
                          onPageFinished: (Object data) async {
                            setState(() {
                              contentWebHeight = double.parse(data.toString());
                            });
                          },
                        ),
                      ),
                      LessonMaterialsWidget(
                        lessonResponse: item,
                        darkMode: true,
                      ),
                    ],
                  );
                }

                return ErrorCustomWidget(
                  onTap: () => BlocProvider.of<LessonZoomBloc>(context).add(
                    FetchEvent(widget.courseId, widget.lessonId),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
