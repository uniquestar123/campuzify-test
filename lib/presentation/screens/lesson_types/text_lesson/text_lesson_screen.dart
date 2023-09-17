import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/presentation/bloc/text_lesson/text_lesson_bloc.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/widgets/lesson_bottom_widget.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/widgets/lesson_materials_widget.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/questions_tab/questions_tab_screen.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/presentation/widgets/warning_lesson_dialog.dart';
import 'package:masterstudy_app/presentation/widgets/webview_widgets/web_view_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class TextLessonScreenArgs {
  TextLessonScreenArgs(
    this.courseId,
    this.lessonId,
    this.authorAva,
    this.authorName,
    this.hasPreview,
    this.trial, {
    this.itemsId,
  });

  final int courseId;
  final int lessonId;
  final String authorAva;
  final String authorName;
  final bool hasPreview;
  final bool trial;
  final dynamic itemsId;
}

class TextLessonScreen extends StatelessWidget {
  static const String routeName = '/textLessonScreen';

  @override
  Widget build(BuildContext context) {
    TextLessonScreenArgs args = ModalRoute.of(context)?.settings.arguments as TextLessonScreenArgs;
    return BlocProvider(
      create: (context) => TextLessonBloc(),
      child: TextLessonWidget(
        args.courseId,
        args.lessonId,
        args.authorAva,
        args.authorName,
        args.hasPreview,
        args.trial,
        itemsId: args.itemsId,
      ),
    );
  }
}

class TextLessonWidget extends StatefulWidget {
  const TextLessonWidget(
    this.courseId,
    this.lessonId,
    this.authorAva,
    this.authorName,
    this.hasPreview,
    this.trial, {
    this.itemsId,
  }) : super();
  final int lessonId;
  final int courseId;
  final String authorAva;
  final String authorName;
  final bool hasPreview;
  final bool trial;
  final dynamic itemsId;

  @override
  State<StatefulWidget> createState() => TextLessonWidgetState();
}

class TextLessonWidgetState extends State<TextLessonWidget> {
  double? contentWebHeight = 300.0;

  @override
  void initState() {
    BlocProvider.of<TextLessonBloc>(context).add(FetchEvent(widget.courseId, widget.lessonId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TextLessonBloc, TextLessonState>(
      listener: (context, state) {
        if (state is CacheWarningLessonState) {
          showDialog(context: context, builder: (context) => WarningLessonDialog());
        }
      },
      child: BlocBuilder<TextLessonBloc, TextLessonState>(
        builder: (BuildContext context, TextLessonState state) {
          String? lessonNumber;
          String? lessonLabel;

          if (state is LoadedTextLessonState) {
            lessonNumber = state.lessonResponse.section?.number;
            lessonLabel = state.lessonResponse.section?.label;
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF273044),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      lessonNumber ?? '',
                      textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                    Text(
                      lessonLabel ?? '',
                      textScaleFactor: 1.0,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
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
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            QuestionsScreen.routeName,
                            arguments: QuestionsScreenArgs(widget.lessonId, 1),
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
            body: Builder(
              builder: (context) {
                if (state is InitialTextLessonState) {
                  return LoaderWidget(
                    loaderColor: ColorApp.mainColor,
                  );
                }

                if (state is LoadedTextLessonState) {
                  return SingleChildScrollView(
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        LessonMaterialsWidget(lessonResponse: state.lessonResponse),
                      ],
                    ),
                  );
                }

                if (state is ErrorTextLessonState) {
                  return ErrorCustomWidget(
                    message: state.message,
                    onTap: () =>
                        BlocProvider.of<TextLessonBloc>(context).add(FetchEvent(widget.courseId, widget.lessonId)),
                  );
                }

                return ErrorCustomWidget(
                  onTap: () =>
                      BlocProvider.of<TextLessonBloc>(context).add(FetchEvent(widget.courseId, widget.lessonId)),
                );
              },
            ),
            bottomNavigationBar: state is LoadedTextLessonState
                ? LessonBottomWidget(
                    lessonResponse: state.lessonResponse,
                    isTrial: widget.trial,
                    courseId: widget.courseId,
                    lessonId: widget.lessonId,
                    authorAva: widget.authorAva,
                    authorName: widget.authorName,
                    hasPreview: widget.hasPreview,
                    trial: widget.trial,
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
