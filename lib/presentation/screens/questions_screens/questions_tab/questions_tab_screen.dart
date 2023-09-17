import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/questions/questions_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/questions_bloc/question_add/question_add_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/questions_bloc/questions/questions_bloc.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/question_ask/question_ask_screen.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/questions_tab/tabs/questions_all_widget.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/questions_tab/tabs/questions_my_widget.dart';
import 'package:masterstudy_app/presentation/widgets/colored_tabbar_widget.dart';
import 'package:masterstudy_app/presentation/widgets/dialog_author.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';

class QuestionsScreenArgs {
  QuestionsScreenArgs(this.lessonId, this.page);

  final int lessonId;
  final int page;
}

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen() : super();

  static const String routeName = '/questionsScreen';

  @override
  Widget build(BuildContext context) {
    QuestionsScreenArgs args = ModalRoute.of(context)?.settings.arguments as QuestionsScreenArgs;

    return BlocProvider(
      create: (context) => QuestionsBloc(),
      child: QuestionsWidget(args.lessonId, args.page),
    );
  }
}

class QuestionsWidget extends StatefulWidget {
  const QuestionsWidget(this.lessonId, this.page) : super();
  final int lessonId;
  final int page;

  @override
  State<StatefulWidget> createState() => QuestionsWidgetState();
}

class QuestionsWidgetState extends State<QuestionsWidget> {
  late QuestionsResponse questionsAll;
  late QuestionsResponse questionsMy;
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<QuestionsBloc>(context).add(LoadQuestionsEvent(widget.lessonId, widget.page, '', ''));
    super.initState();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestionAddBloc(),
      child: BlocListener<QuestionAddBloc, QuestionAddState>(
        listener: (context, state) {
          if (state is SuccessQuestionAddState) {
            BlocProvider.of<QuestionsBloc>(context).add(LoadQuestionsEvent(widget.lessonId, widget.page, '', ''));
          }

          if (state is ErrorQuestionAddState) {
            showFlutterToast(title: state.message);
          }
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF273044),
              title: Text(
                localizations.getLocalization('back_to_course'),
                textScaleFactor: 1.0,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              bottom: ColoredTabBar(
                Colors.white,
                TabBar(
                  indicatorColor: ColorApp.mainColor,
                  tabs: [
                    Tab(
                      text: localizations.getLocalization('all_questions'),
                    ),
                    Tab(
                      text: localizations.getLocalization('my_questions'),
                    ),
                  ],
                ),
              ),
            ),
            body: BlocBuilder<QuestionsBloc, QuestionsState>(
              builder: (context, state) {
                if (state is InitialQuestionsState) {
                  return LoaderWidget(
                    loaderColor: ColorApp.mainColor,
                  );
                }

                if (state is LoadedQuestionsState) {
                  questionsAll = state.questionsResponseAll;
                  questionsMy = state.questionsResponseMy;

                  return TabBarView(
                    children: <Widget>[
                      QuestionAllWidget(
                        questionsAll: questionsAll,
                        lessonId: widget.lessonId,
                      ),
                      QuestionsMyWidget(
                        questionsMy: questionsMy,
                        lessonId: widget.lessonId,
                      ),
                    ],
                  );
                }

                return ErrorCustomWidget(
                  onTap: () => BlocProvider.of<QuestionsBloc>(context).add(
                    LoadQuestionsEvent(widget.lessonId, widget.page, '', ''),
                  ),
                );
              },
            ),
            bottomNavigationBar: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFF273044),
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
                padding: const EdgeInsets.all(15.0),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: MaterialButton(
                    height: kButtonHeight,
                    color: ColorApp.mainColor,
                    onPressed: () {
                      if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                        showDialogError(context, localizations.getLocalization('demo_mode'));
                      } else {
                        Navigator.of(context).pushNamed(
                          QuestionAskScreen.routeName,
                          arguments: QuestionAskScreenArgs(widget.lessonId),
                        );
                      }
                    },
                    child: Text(
                      localizations.getLocalization('ask_your_question'),
                      textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
