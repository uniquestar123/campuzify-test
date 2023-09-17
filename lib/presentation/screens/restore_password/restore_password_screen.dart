import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/restore_password/restore_password_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/alert_dialogs.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class RestorePasswordScreen extends StatelessWidget {
  const RestorePasswordScreen() : super();

  static const String routeName = '/restorePasswordScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorApp.mainColor,
        title: Text(
          localizations.getLocalization('restore_password_button'),
          textScaleFactor: 1.0,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: BlocProvider(
        create: (context) => RestorePasswordBloc(),
        child: _RestorePasswordWidget(),
      ),
    );
  }
}

class _RestorePasswordWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RestorePasswordWidgetState();
}

class _RestorePasswordWidgetState extends State<_RestorePasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RestorePasswordBloc, RestorePasswordState>(
      listener: (context, state) {
        if (state is SuccessRestorePasswordState) {
          showFlutterToast(
            title: localizations.getLocalization('restore_password_info'),
          );
        }

        if (state is ErrorRestorePasswordState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showAlertDialog(
              context,
              content: unescape.convert(state.message),
            ),
          );
        }
      },
      child: BlocBuilder<RestorePasswordBloc, RestorePasswordState>(
        builder: (context, state) {
          var enableInputs = !(state is LoadingRestorePasswordState);
          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
              child: Column(
                children: [
                  //Email
                  TextFormField(
                    controller: _emailController,
                    enabled: enableInputs,
                    autofocus: true,
                    cursorColor: ColorApp.mainColor,
                    decoration: InputDecoration(
                      labelText: localizations.getLocalization('email_label_text'),
                      helperText: localizations.getLocalization('email_helper_text'),
                      filled: true,
                      labelStyle: TextStyle(
                        color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorApp.mainColor),
                      ),
                    ),
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 20.0),
                  MaterialButton(
                    minWidth: double.infinity,
                    color: ColorApp.mainColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<RestorePasswordBloc>(context)
                            .add(SendRestorePasswordEvent(_emailController.text));
                      }
                    },
                    child: state is LoadingRestorePasswordState
                        ? LoaderWidget()
                        : Text(
                            localizations.getLocalization('restore_password_button'),
                            textScaleFactor: 1.0,
                          ),
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
