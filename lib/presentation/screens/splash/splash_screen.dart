import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/splash/splash_bloc.dart';
import 'package:masterstudy_app/presentation/screens/main_screens.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/splashScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SplashBloc()..add(LoadSplashEvent()),
        child: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is CloseSplashState) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainScreen.routeName,
                    arguments: MainScreenArgs(state.appSettings!.options!),
                    (_) => false,
                  );
                },
              );
            }
          },
          child: BlocBuilder<SplashBloc, SplashState>(
            builder: (context, state) {
              if (state is InitialSplashState) {
                return LoaderWidget();
              }

              if (state is ErrorSplashState) {
                return ErrorCustomWidget(
                  onTap: () => BlocProvider.of<SplashBloc>(context).add(LoadSplashEvent()),
                  message: state.message ?? localizations.getLocalization('unknown_error'),
                );
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: preferences.getString(PreferencesName.appLogo) ?? '',
                      placeholder: (context, url) {
                        return LoaderWidget();
                      },
                      errorWidget: (context, url, error) {
                        return Image.asset(ImagePath.logo);
                      },
                      width: 83.0,
                    ),
                    //Count course
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
                      child: state is LoadingSplashState
                          ? LoaderWidget(loaderColor: ColorApp.mainColor)
                          : Text(
                              state is CloseSplashState ? state.appSettings!.options!.postsCount.toString() : '',
                              style: TextStyle(
                                color: ColorApp.mainColor,
                                fontSize: 40.0,
                              ),
                            ),
                    ),
                    //Text "Course"
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: state is CloseSplashState
                          ? Text(
                              localizations.getLocalization('profile_courses_tab').toUpperCase(),
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : const SizedBox(),
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
