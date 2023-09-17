import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/routes/app_routes.dart';
import 'package:masterstudy_app/data/repository/localization_repository.dart';
import 'package:masterstudy_app/firebase_options.dart';
import 'package:masterstudy_app/presentation/bloc/course/course_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/courses/user_courses_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/home_simple/home_simple_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/search/search_screen_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/components/google_signin.dart';
import 'package:masterstudy_app/presentation/screens/splash/splash_screen.dart';
import 'package:masterstudy_app/theme/app_theme.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

LocalizationRepository localizations = LocalizationRepository();

bool dripContentEnabled = false;
bool? demoEnabled = false;
bool? googleOauth = false;
bool? facebookOauth = false;
bool appView = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.grey.withOpacity(0.4), // top bar color
      statusBarIconBrightness: Brightness.light, // top bar icons color
    ),
  );

  GoogleSignInProvider().initializeGoogleSignIn();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  preferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  appView = preferences.getBool(PreferencesName.appView) ?? false;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp() : super();

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeSimpleBloc>(
          create: (BuildContext context) => HomeSimpleBloc()..add(LoadHomeSimpleEvent()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (BuildContext context) => FavoritesBloc(),
        ),
        BlocProvider<SearchScreenBloc>(
          create: (BuildContext context) => SearchScreenBloc(),
        ),
        BlocProvider<UserCoursesBloc>(
          create: (BuildContext context) => UserCoursesBloc(),
        ),
        BlocProvider<EditProfileBloc>(
          create: (BuildContext context) => EditProfileBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => ProfileBloc(),
        ),
        BlocProvider<CourseBloc>(
          create: (BuildContext context) => CourseBloc(),
        ),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          title: 'Campuzify Mobile',
          theme: AppTheme().themeLight,
          initialRoute: SplashScreen.routeName,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          onGenerateRoute: (RouteSettings settings) => AppRoutes().generateRoute(settings, context),
          onUnknownRoute: (RouteSettings settings) => AppRoutes().onUnknownRoute(settings, context),
        ),
      ),
    );
  }
}
