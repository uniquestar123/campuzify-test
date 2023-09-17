import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/questions/questions_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/questions_bloc/question_add/question_add_bloc.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/widgets/answer_item_widget.dart';
import 'package:masterstudy_app/presentation/widgets/dialog_author.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class QuestionsMyWidget extends StatefulWidget {
  const QuestionsMyWidget({
    Key? key,
    required this.questionsMy,
    required this.lessonId,
  }) : super(key: key);

  final QuestionsResponse questionsMy;
  final int lessonId;

  @override
  State<QuestionsMyWidget> createState() => _QuestionsMyWidgetState();
}

class _QuestionsMyWidgetState extends State<QuestionsMyWidget> {
  List<TextEditingController> _controllers = [];

  @override
  Widget build(BuildContext context) {
    if (widget.questionsMy.posts.isEmpty) {
      return Center(
        child: Text(
          localizations.getLocalization('no_questions'),
          textScaleFactor: 1.0,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      itemCount: widget.questionsMy.posts.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0.0,
          color: Color(0xFFEBEDEF),
        );
      },
      itemBuilder: (BuildContext ctx, int index) {
        _controllers.add(TextEditingController());

        return MyQuestionItem(
          question: widget.questionsMy.posts[index]!,
          controller: _controllers[index],
          lessonId: widget.lessonId,
        );
      },
    );
  }
}

class MyQuestionItem extends StatelessWidget {
  const MyQuestionItem({
    Key? key,
    required this.question,
    required this.controller,
    required this.lessonId,
  }) : super(key: key);

  final QuestionBean question;
  final TextEditingController controller;
  final int lessonId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionAddBloc, QuestionAddState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      question.content!,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF273044),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      question.dateTime!,
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        color: Color(0xFFAAAAAA),
                      ),
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    maxLines: 2,
                    controller: controller,
                    cursorColor: ColorApp.mainColor,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: localizations.getLocalization('enter_your_answer'),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorApp.mainColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: ColorApp.secondaryColor),
                        onPressed: state is LoadingQuestionAddState
                            ? null
                            : () {
                                if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                                  showDialogError(context, localizations.getLocalization('demo_mode'));
                                } else {
                                  if (controller.text != '') {
                                    BlocProvider.of<QuestionAddBloc>(context).add(
                                      AddQuestionEvent(
                                        lessonId: lessonId,
                                        comment: controller.text,
                                        parent: int.parse(question.commentId!),
                                      ),
                                    );

                                    controller.clear();
                                  }
                                }
                              },
                        child: state is LoadingQuestionAddState
                            ? LoaderWidget()
                            : Text(
                                localizations.getLocalization('submit_button'),
                                textScaleFactor: 1.0,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (var reply in question.replies)
                    AnswerItem(
                      dateTime: reply?.datetime,
                      content: reply?.content,
                      authorName: reply?.author?.login,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
