import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/question_add/question_add_response.dart';
import 'package:masterstudy_app/data/models/questions/questions_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/questions_bloc/question_details/question_details_bloc.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/widgets/answer_item_widget.dart';
import 'package:masterstudy_app/presentation/widgets/dialog_author.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class QuestionDetailsScreenArgs {
  QuestionDetailsScreenArgs(this.lessonId, this.questionBean);

  final QuestionBean questionBean;
  final int lessonId;
}

class QuestionDetailsScreen extends StatelessWidget {
  const QuestionDetailsScreen() : super();
  static const String routeName = '/questionDetailsScreen';

  @override
  Widget build(BuildContext context) {
    QuestionDetailsScreenArgs args = ModalRoute.of(context)?.settings.arguments as QuestionDetailsScreenArgs;
    return BlocProvider(
      create: (context) => QuestionDetailsBloc(),
      child: QuestionDetailsWidget(args.lessonId, args.questionBean),
    );
  }
}

class QuestionDetailsWidget extends StatefulWidget {
  const QuestionDetailsWidget(this.lessonId, this.questionBean) : super();

  final QuestionBean questionBean;
  final int lessonId;

  @override
  State<StatefulWidget> createState() => QuestionDetailsWidgetState();
}

class QuestionDetailsWidgetState extends State<QuestionDetailsWidget> {
  TextEditingController _replyTextController = TextEditingController();
  List<QuestionAddBean> _newRepliesList = [];
  List<ReplyBean?> _repliesList = [];

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    _repliesList = widget.questionBean.replies;
    super.initState();
  }

  @override
  void dispose() {
    _replyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionDetailsBloc, QuestionDetailsState>(
      listener: (context, state) {
        if (state is ReplyAddedState) {
          setState(() {
            _newRepliesList.insert(0, state.questionAddResponse.comment!);
            _replyTextController.clear();
          });
        }

        if (state is ReplyErrorState) {
          showFlutterToast(title: state.message);
        }
      },
      child: BlocBuilder<QuestionDetailsBloc, QuestionDetailsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF273044),
              title: Text(
                localizations.getLocalization('question_ask_screen_title'),
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Html(
                            data: widget.questionBean.content,
                            style: {
                              'body': Style(
                                fontSize: FontSize(17.0),
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF273044),
                              )
                            },
                          ),
                        ),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.questionBean.author!.login,
                                textScaleFactor: 1.0,
                                style: TextStyle(color: ColorApp.mainColor),
                              ),
                              VerticalDivider(
                                width: 40,
                                indent: 2,
                                endIndent: 2,
                                thickness: 2,
                                color: Color(0xFFE2E5EB),
                              ),
                              Text(
                                widget.questionBean.dateTime!,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  color: Color(0xFFAAAAAA),
                                ),
                              ),
                              VerticalDivider(
                                width: 40,
                                indent: 2,
                                endIndent: 2,
                                thickness: 2,
                                color: Color(0xFFE2E5EB),
                              ),
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: SvgPicture.asset(
                                  IconPath.flag,
                                  color: Color(0xFFAAAAAA),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            controller: _replyTextController,
                            maxLines: 2,
                            textAlignVertical: TextAlignVertical.top,
                            cursorColor: ColorApp.mainColor,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorApp.mainColor),
                              ),
                              labelStyle: TextStyle(color: myFocusNode.hasFocus ? ColorApp.mainColor : Colors.black),
                              labelText: localizations.getLocalization('enter_your_answer'),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                          child: SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorApp.secondaryColor,
                              ),
                              onPressed: state is ReplyAddingState
                                  ? null
                                  : () {
                                      if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                                        showDialogError(context, localizations.getLocalization('demo_mode'));
                                      } else {
                                        if (_replyTextController.text != '') {
                                          BlocProvider.of<QuestionDetailsBloc>(context).add(
                                            QuestionAddEvent(
                                              widget.lessonId,
                                              _replyTextController.text,
                                              int.tryParse(widget.questionBean.commentId!)!,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              child: state is ReplyAddingState
                                  ? LoaderWidget()
                                  : Text(
                                      localizations.getLocalization('submit_question_answer'),
                                      textScaleFactor: 1.0,
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                    _buildAddedReply(),
                    _buildList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddedReply() {
    if (_newRepliesList.isEmpty) {
      return const SizedBox();
    }

    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: _newRepliesList.length,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final item = _newRepliesList[index];
        return AnswerItem(
          dateTime: item.datetime,
          content: item.content,
          authorName: item.author?.login,
        );
      },
    );
  }

  Widget _buildList() {
    if (_repliesList.isEmpty) {
      return const SizedBox();
    }

    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: _repliesList.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = _repliesList[index];

        return AnswerItem(
          dateTime: item?.datetime,
          content: item?.content,
          authorName: item?.author?.login,
        );
      },
    );
  }
}
