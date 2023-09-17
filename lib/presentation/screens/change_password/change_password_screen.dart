import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/change_password/change_password_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';
import 'package:masterstudy_app/theme/const_styles.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen() : super();

  static const String routeName = '/changePasswordScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.getLocalization('change_password '),
          style: kAppBarTextStyle,
        ),
        backgroundColor: ColorApp.mainColor,
      ),
      body: BlocProvider(
        create: (context) => ChangePasswordBloc(),
        child: ChangePasswordWidget(),
      ),
    );
  }
}

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({Key? key}) : super(key: key);

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = FocusNode();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordConfirmController = TextEditingController();

  bool obscureText = true;
  bool obscureText1 = true;
  bool obscureText2 = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordConfirmController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is SuccessChangePasswordState) {
          showFlutterToast(
            title: localizations.getLocalization('password_is_changed'),
          );

          Navigator.of(context).pop();
        }

        if (state is ErrorChangePasswordState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showDialogError(context, state.message),
          );
        }
      },
      child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
          final enableInputs = !(state is LoadingChangePasswordState);

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                  child: TextFormField(
                    controller: oldPasswordController,
                    enabled: enableInputs,
                    cursorColor: ColorApp.mainColor,
                    validator: (val) {
                      if (val!.isEmpty) return localizations.getLocalization('password_empty_error_text');

                      return null;
                    },
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: localizations.getLocalization('current_password'),
                      helperText: localizations.getLocalization('current_password_helper'),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: ColorApp.mainColor,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
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
                    // validator: _validateEmail,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                  child: TextFormField(
                    controller: newPasswordController,
                    enabled: enableInputs,
                    cursorColor: ColorApp.mainColor,
                    obscureText: obscureText1,
                    validator: (val) {
                      if (val!.isEmpty) return localizations.getLocalization('password_empty_error_text');

                      if (val.length < 8) {
                        return localizations.getLocalization('password_register_characters_count_error_text');
                      }

                      if (RegExp(r'^[a-zA-Z]+$').hasMatch(val)) {
                        return localizations.getLocalization('password_register_characters_count_error_text');
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: localizations.getLocalization('new_password'),
                      helperText: localizations.getLocalization('password_registration_helper_text'),
                      filled: true,
                      labelStyle: TextStyle(
                        color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText1 ? Icons.visibility : Icons.visibility_off,
                          color: ColorApp.mainColor,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText1 = !obscureText1;
                          });
                        },
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorApp.mainColor),
                      ),
                    ),
                    // validator: _validateEmail,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                  child: TextFormField(
                    controller: newPasswordConfirmController,
                    enabled: enableInputs,
                    cursorColor: ColorApp.mainColor,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return localizations.getLocalization('password_empty_error_text');
                      }

                      if (newPasswordController.text != newPasswordConfirmController.text) {
                        return localizations.getLocalization('password_dont_match');
                      }

                      return null;
                    },
                    obscureText: obscureText2,
                    decoration: InputDecoration(
                      labelText: localizations.getLocalization('confirm_password'),
                      helperText: localizations.getLocalization('confirm_password_helper'),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText2 ? Icons.visibility : Icons.visibility_off,
                          color: ColorApp.mainColor,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText2 = !obscureText2;
                          });
                        },
                      ),
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
                    // validator: _validateEmail,
                  ),
                ),
                Container(
                  height: kButtonHeight,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorApp.mainColor,
                    ),
                    child: state is LoadingChangePasswordState
                        ? LoaderWidget()
                        : Text(
                            localizations.getLocalization('change_password'),
                            textScaleFactor: 1.0,
                          ),
                    onPressed: state is LoadingChangePasswordState
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<ChangePasswordBloc>(context)
                                  .add(SendChangePasswordEvent(oldPasswordController.text, newPasswordController.text));
                            }
                          },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showDialogError(context, text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            localizations.getLocalization('error_dialog_title'),
            textScaleFactor: 1.0,
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          content: Text(text ?? localizations.getLocalization('error_dialog_title')),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.mainColor,
              ),
              child: Text(
                localizations.getLocalization('ok_dialog_button'),
                textScaleFactor: 1.0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
