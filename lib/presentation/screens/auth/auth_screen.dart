import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/widget/sign_in.dart';
import 'package:masterstudy_app/presentation/screens/auth/widget/sign_up.dart';
import 'package:masterstudy_app/presentation/screens/main_screens.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class AuthScreenArgs {
  AuthScreenArgs({this.optionsBean, this.withoutToken = false});

  final OptionsBean? optionsBean;
  final bool withoutToken;
}

class AuthScreen extends StatelessWidget {
  static const String routeName = '/authScreen';

  @override
  Widget build(BuildContext context) {
    final AuthScreenArgs args = ModalRoute.of(context)?.settings.arguments as AuthScreenArgs;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => EditProfileBloc(),
        ),
      ],
      child: AuthScreenWidget(
        optionsBean: args.optionsBean!,
        withoutToken: args.withoutToken,
        key: key,
      ),
    );
  }
}

class AuthScreenWidget extends StatelessWidget {
  const AuthScreenWidget({
    Key? key,
    required this.optionsBean,
    required this.withoutToken,
  }) : super(key: key);
  final OptionsBean optionsBean;
  final bool withoutToken;

  String? get appLogo => preferences.getString(PreferencesName.appLogo);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0), // here th
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorApp.mainColor,
              ),
              onPressed: () {
                if (withoutToken) {
                  Navigator.of(context).pushReplacementNamed(
                    MainScreen.routeName,
                    arguments: MainScreenArgs(optionsBean),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: CachedNetworkImage(
                width: 50.0,
                imageUrl: appLogo ?? '',
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) {
                  return SizedBox(
                    width: 83.0,
                    child: Image.asset(ImagePath.logo),
                  );
                },
              ),
            ),
            bottom: TabBar(
              indicatorColor: ColorApp.mainColor,
              tabs: [
                //SignUp
                Tab(
                  icon: Text(
                    localizations.getLocalization('auth_sign_up_tab'),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: ColorApp.mainColor),
                  ),
                ),
                //SignIn
                Tab(
                  icon: Text(
                    localizations.getLocalization('auth_sign_in_tab'),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: ColorApp.mainColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              //SignUp
              ListView(
                children: <Widget>[
                  SignUpPage(
                    optionsBean: optionsBean,
                  )
                ],
              ),
              //SignIn
              ListView(
                children: <Widget>[
                  SignInPage(
                    optionsBean: optionsBean,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
