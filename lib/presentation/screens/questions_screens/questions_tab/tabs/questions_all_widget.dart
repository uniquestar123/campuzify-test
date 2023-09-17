import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/questions/questions_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/question_details/question_details_screen.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class QuestionAllWidget extends StatelessWidget {
  const QuestionAllWidget({
    Key? key,
    required this.questionsAll,
    required this.lessonId,
  }) : super(key: key);

  final QuestionsResponse questionsAll;
  final int lessonId;

  @override
  Widget build(BuildContext context) {
    if (questionsAll.posts.isEmpty) {
      return Center(
        child: Text(
          localizations.getLocalization('no_questions'),
          textScaleFactor: 1.0,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: questionsAll.posts.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0.0,
          color: Color(0xFFEBEDEF),
        );
      },
      itemBuilder: (BuildContext ctx, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            QuestionsItem(
              questionBean: questionsAll.posts[index]!,
              lessonId: lessonId,
            ),
          ],
        );
      },
    );
  }
}

class QuestionsItem extends StatelessWidget {
  const QuestionsItem({Key? key, required this.questionBean, required this.lessonId}) : super(key: key);

  final QuestionBean questionBean;
  final int lessonId;

  Color get repliesColor => questionBean.replies.length == 0 ? Color(0xFFAAAAAA) : ColorApp.secondaryColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          QuestionDetailsScreen.routeName,
          arguments: QuestionDetailsScreenArgs(lessonId, questionBean),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              questionBean.content!,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                color: Color(0xFF273044),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    questionBean.replies.length == 0 ? IconPath.replyNo : IconPath.reply,
                    color: repliesColor,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  questionBean.repliesCount!,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: repliesColor,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
