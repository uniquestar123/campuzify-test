import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/components/google_signin.dart';
import 'package:masterstudy_app/presentation/screens/auth/widget/socials_widget.dart';
import 'package:masterstudy_app/presentation/screens/main_screens.dart';
import 'package:masterstudy_app/presentation/screens/restore_password/restore_password_screen.dart';
import 'package:masterstudy_app/presentation/widgets/alert_dialogs.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.optionsBean}) : super(key: key);

  final OptionsBean optionsBean;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  bool passwordVisible = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SuccessSignInState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.pushReplacementNamed(
              context,
              MainScreen.routeName,
              arguments: MainScreenArgs(widget.optionsBean, selectedIndex: 4),
            ),
          );
        }

        if (state is ErrorSignInState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showAlertDialog(
              context,
              title: localizations.getLocalization('error_dialog_title'),
              content: state.message,
              onPressed: () => BlocProvider.of<AuthBloc>(context).add(CloseDialogEvent()),
            ),
          );
        }

        //Socials State
        if (state is SuccessAuthSocialsState) {
          if (state.photoUrl != null) {
            BlocProvider.of<EditProfileBloc>(context).add(UploadPhotoProfileEvent(state.photoUrl));
          }

          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.pushReplacementNamed(
              context,
              MainScreen.routeName,
              arguments: MainScreenArgs(
                widget.optionsBean,
                selectedIndex: 4,
              ),
            ),
          );
        }

        if (state is ErrorAuthSocialsState) {
          GoogleSignInProvider().logoutGoogle();
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showAlertDialog(
              context,
              title: localizations.getLocalization('error_dialog_title'),
              content: state.message,
              onPressed: () => BlocProvider.of<AuthBloc>(context).add(CloseDialogEvent()),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          var enableInputs = !(state is LoadingSignInState);

          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: <Widget>[
                  //Login
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: TextFormField(
                      controller: _loginController,
                      enabled: enableInputs,
                      cursorColor: ColorApp.mainColor,
                      decoration: InputDecoration(
                        labelText: localizations.getLocalization('login_label_text'),
                        helperText: localizations.getLocalization('login_sign_in_helper_text'),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return localizations.getLocalization('login_sign_in_helper_text');
                        }
                        return null;
                      },
                    ),
                  ),
                  //Password
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextFormField(
                      controller: _passwordController,
                      enabled: enableInputs,
                      obscureText: passwordVisible,
                      cursorColor: ColorApp.mainColor,
                      decoration: InputDecoration(
                        labelText: localizations.getLocalization('password_label_text'),
                        helperText: localizations.getLocalization('password_sign_in_helper_text'),
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          color: ColorApp.mainColor,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return localizations.getLocalization('password_sign_in_helper_text');
                        }

                        if (value.length < 4) {
                          return localizations.getLocalization('password_sign_in_characters_count_error_text');
                        }

                        return null;
                      },
                    ),
                  ),
                  //Button "Sign In"
                  SizedBox(
                    height: kButtonHeight,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorApp.mainColor,
                      ),
                      onPressed: state is LoadingSignInState
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                if (_loginController.text == 'demoapp' && _passwordController.text == 'demoapp') {
                                  preferences.setBool(PreferencesName.demoMode, true);
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(SignInEvent(_loginController.text, _passwordController.text));
                                } else {
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(SignInEvent(_loginController.text, _passwordController.text));
                                }
                              }
                            },
                      child: state is LoadingSignInState
                          ? LoaderWidget()
                          : Text(
                              localizations.getLocalization('sign_in_button'),
                              textScaleFactor: 1.0,
                            ),
                    ),
                  ),
                  //RestorePassword
                  TextButton(
                    child: Text(
                      localizations.getLocalization('restore_password_button'),
                      style: TextStyle(color: ColorApp.mainColor),
                      textScaleFactor: 1.0,
                    ),
                    onPressed: () => Navigator.of(context).pushNamed(RestorePasswordScreen.routeName),
                  ),
                  const SizedBox(height: 20),
                  //Socials Sign In
                  SocialsWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
