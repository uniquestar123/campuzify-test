import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/presentation/screens/auth/components/google_signin.dart';
import 'package:masterstudy_app/presentation/screens/detail_profile/detail_profile_screen.dart';
import 'package:masterstudy_app/presentation/screens/orders/orders_screen.dart';
import 'package:masterstudy_app/presentation/screens/profile/widgets/profile_widget.dart';
import 'package:masterstudy_app/presentation/screens/profile/widgets/tile_item.dart';
import 'package:masterstudy_app/presentation/screens/profile_edit/profile_edit_screen.dart';
import 'package:masterstudy_app/presentation/screens/splash/splash_screen.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/presentation/widgets/unauthorized_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen(this.myCoursesCallback, {this.optionsBean}) : super();

  final Function myCoursesCallback;
  final OptionsBean? optionsBean;

  @override
  Widget build(BuildContext context) => ProfileScreenWidget(myCoursesCallback, optionsBean: optionsBean);
}

class ProfileScreenWidget extends StatefulWidget {
  const ProfileScreenWidget(this.myCoursesCallback, {this.optionsBean}) : super();
  final Function myCoursesCallback;
  final OptionsBean? optionsBean;

  @override
  State<StatefulWidget> createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget> {
  @override
  void initState() {
    if (BlocProvider.of<ProfileBloc>(context).state is! LoadedProfileState) {
      BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is LogoutProfileState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.of(context).pushNamedAndRemoveUntil(
              SplashScreen.routeName,
              (Route<dynamic> route) => false,
            ),
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          if (state is InitialProfileState) {
            return LoaderWidget(
              loaderColor: ColorApp.mainColor,
            );
          }

          if (state is UnauthorizedState) {
            return UnauthorizedWidget(
              onTap: () => Navigator.pushNamed(
                context,
                AuthScreen.routeName,
                arguments: AuthScreenArgs(optionsBean: widget.optionsBean),
              ),
            );
          }

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                backgroundColor: ColorApp.mainColor,
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    // Header Profile
                    BlocProvider.value(
                      value: BlocProvider.of<ProfileBloc>(context),
                      child: ProfileWidget(
                        optionsBean: widget.optionsBean,
                      ),
                    ),

                    // Divider
                    Divider(
                      height: 5.0,
                      thickness: 1.0,
                      color: Color(0xFFE5E5E5),
                    ),

                    // View my profile
                    TileWidget(
                      title: localizations.getLocalization('view_my_profile'),
                      assetPath: IconPath.profileIcon,
                      onClick: () {
                        if (state is LoadedProfileState)
                          Navigator.pushNamed(
                            context,
                            DetailProfileScreen.routeName,
                            arguments: DetailProfileScreenArgs(
                              optionsBean: widget.optionsBean,
                            ),
                          );
                      },
                    ),

                    // My orders
                    TileWidget(
                      title: localizations.getLocalization('my_orders'),
                      assetPath: IconPath.orders,
                      onClick: () {
                        Navigator.of(context).pushNamed(OrdersScreen.routeName);
                      },
                    ),

                    // My courses
                    TileWidget(
                      title: localizations.getLocalization('my_courses'),
                      assetPath: IconPath.navCourses,
                      onClick: () => widget.myCoursesCallback(),
                    ),

                    // Settings
                    TileWidget(
                      title: localizations.getLocalization('settings'),
                      assetPath: IconPath.settings,
                      onClick: () {
                        if (state is LoadedProfileState) {
                          Navigator.pushNamed(
                            context,
                            ProfileEditScreen.routeName,
                            arguments: ProfileEditScreenArgs(state.account),
                          );
                        }
                      },
                    ),

                    // Logout
                    TileWidget(
                      title: localizations.getLocalization('logout'),
                      assetPath: IconPath.logout,
                      onClick: () => _showLogoutDialog(context),
                      textColor: ColorApp.lipstick,
                      iconColor: ColorApp.lipstick,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.getLocalization('logout'),
            textScaleFactor: 1.0,
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          content: Text(
            localizations.getLocalization('logout_message'),
            textScaleFactor: 1.0,
          ),
          actions: [
            TextButton(
              child: Text(
                localizations.getLocalization('cancel_button'),
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: ColorApp.mainColor,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                localizations.getLocalization('logout'),
                textScaleFactor: 1.0,
                style: TextStyle(color: ColorApp.mainColor),
              ),
              onPressed: () {
                GoogleSignInProvider().logoutGoogle();
                BlocProvider.of<ProfileBloc>(context).add(LogoutProfileEvent());
              },
            ),
          ],
        );
      },
    );
  }
}
