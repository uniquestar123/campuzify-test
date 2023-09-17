import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/questions_bloc/question_ask/question_ask_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';

class QuestionAskScreenArgs {
  QuestionAskScreenArgs(this.lessonId);

  final int lessonId;
}

class QuestionAskScreen extends StatelessWidget {
  const QuestionAskScreen() : super();
  static const String routeName = '/questionAskScreen';

  @override
  Widget build(BuildContext context) {
    QuestionAskScreenArgs args = ModalRoute.of(context)?.settings.arguments as QuestionAskScreenArgs;
    return BlocProvider(
      create: (context) => QuestionAskBloc(),
      child: QuestionAskWidget(args.lessonId),
    );
  }
}

class QuestionAskWidget extends StatefulWidget {
  const QuestionAskWidget(this.lessonId) : super();

  final int lessonId;

  @override
  State<StatefulWidget> createState() => QuestionAskWidgetState();
}

class QuestionAskWidgetState extends State<QuestionAskWidget> {
  final TextEditingController _reviewController = TextEditingController();
  FocusNode myFocusNode = new FocusNode();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF273044),
        title: Text(
          localizations.getLocalization('question_ask_screen_title'),
          textScaleFactor: 1.0,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: BlocListener<QuestionAskBloc, QuestionAskState>(
          listener: (context, state) {
            if (state is SuccessAddQuestionState) {
              _reviewController.clear();
              Navigator.of(context).pop();
            }
            if (state is ErrorAddQuestionState) {
              showFlutterToast(title: state.message ?? 'Unknown Error');
            }
          },
          child: BlocBuilder<QuestionAskBloc, QuestionAskState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      localizations.getLocalization('ask_your_question'),
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        color: Color(0xFF273044),
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: _reviewController,
                        maxLines: 8,
                        autofocus: true,
                        cursorColor: ColorApp.mainColor,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorApp.mainColor),
                          ),
                          labelStyle: TextStyle(color: myFocusNode.hasFocus ? ColorApp.mainColor : Colors.black),
                          labelText: localizations.getLocalization('enter_review'),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kButtonHeight,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.secondaryColor,
                          shadowColor: ColorApp.secondaryColor,
                        ),
                        onPressed: state is LoadingAddQuestionState?
                            ? null
                            : () {
                                if (_reviewController.text != '') {
                                  BlocProvider.of<QuestionAskBloc>(context).add(
                                    QuestionAddEvent(widget.lessonId, _reviewController.text),
                                  );
                                }
                              },
                        child: state is LoadingAddQuestionState
                            ? LoaderWidget()
                            : Text(
                                localizations.getLocalization('submit_button'),
                                textScaleFactor: 1.0,
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
