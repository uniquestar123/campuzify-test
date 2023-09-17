import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/components/google_signin.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class SocialsWidget extends StatelessWidget {
  const SocialsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //OR
        Visibility(
          visible: !googleOauth! && !facebookOauth! ? false : true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Divider(
                  thickness: 0.4,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.grey,
                ),
              ),
              Text(
                localizations.getLocalization('or'),
                style: TextStyle(
                  fontSize: 18,
                  color: ColorApp.mainColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 0.4,
                  color: Colors.grey,
                  endIndent: 20,
                  indent: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        //Socials
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Google
                Visibility(
                  visible: googleOauth! ? true : false,
                  child: Container(
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffC94130),
                      ),
                      onPressed: state is LoadingAuthGoogleState
                          ? null
                          : () async {
                              GoogleSignInProvider().signInGoogle().then((value) async {
                                var ggAuth = await value.authentication;
                                var ggAuthProfile = value.photoUrl;

                                if (ggAuthProfile != null) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    AuthSocialsEvent(
                                      providerType: 'google',
                                      idToken: ggAuth.idToken!,
                                      accessToken: ggAuth.accessToken!,
                                      photoUrl: await urlToFile(ggAuthProfile),
                                    ),
                                  );
                                }
                              });
                            },
                      child: state is LoadingAuthGoogleState
                          ? LoaderWidget()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.google),
                                const SizedBox(width: 5),
                                Text('Google'),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                //Facebook
                Visibility(
                  visible: facebookOauth! ? true : false,
                  child: Container(
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff2A77F3),
                      ),
                      onPressed: state is LoadingAuthFacebookState
                          ? null
                          : () async {
                              final LoginResult result = await FacebookAuth.instance.login(
                                permissions: ['email', 'public_profile'],
                              );

                              if (result.status == LoginStatus.success) {
                                final AccessToken accessToken = result.accessToken!;

                                final userData = await FacebookAuth.instance.getUserData();

                                BlocProvider.of<AuthBloc>(context).add(
                                  AuthSocialsEvent(
                                    providerType: 'facebook',
                                    accessToken: accessToken.token,
                                    photoUrl: await urlToFile(userData['picture']['data']['url']),
                                  ),
                                );
                              }
                            },
                      child: state is LoadingAuthFacebookState
                          ? LoaderWidget()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.facebookF),
                                const SizedBox(width: 5),
                                Text('Facebook'),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
