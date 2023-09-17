import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/courses/user_courses_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/presentation/screens/category_detail/category_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/user_course/user_course.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/presentation/widgets/unauthorized_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen(
    this.addCoursesCallback, {
    this.optionsBean,
  }) : super();

  final Function addCoursesCallback;
  final OptionsBean? optionsBean;

  @override
  Widget build(BuildContext context) => _CoursesWidget(
        addCoursesCallback,
        optionsBean: optionsBean,
      );
}

class _CoursesWidget extends StatefulWidget {
  _CoursesWidget(
    this.addCoursesCallback, {
    this.optionsBean,
  }) : super();

  final Function addCoursesCallback;
  final OptionsBean? optionsBean;

  @override
  State<StatefulWidget> createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<_CoursesWidget> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  HttpService _httpService = HttpService();

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    BlocProvider.of<UserCoursesBloc>(context).add(LoadUserCoursesEvent());
    updateCompletedLesson();
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateCompletedLesson();
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: ColorApp.mainColor,
        title: Text(
          localizations.getLocalization('user_courses_screen_title'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<UserCoursesBloc, UserCoursesState>(
        builder: (context, state) {
          if (state is UnauthorizedState) {
            return UnauthorizedWidget(
              onTap: () => Navigator.pushNamed(
                context,
                AuthScreen.routeName,
                arguments: AuthScreenArgs(optionsBean: widget.optionsBean),
              ),
            );
          }

          if (state is EmptyCoursesState) {
            return EmptyWidget(
              iconData: IconPath.emptyCourses,
              title: localizations.getLocalization('no_user_courses_screen_title'),
              onTap: () => widget.addCoursesCallback(),
              buttonText: localizations.getLocalization('add_courses_button'),
            );
          }

          if (state is EmptyCacheCoursesState) {
            return EmptyWidget(
              iconData: IconPath.emptyCourses,
              title: localizations.getLocalization('courses_is_empty'),
            );
          }

          if (state is LoadedCoursesState) {
            return ListView.builder(
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                final courses = state.courses[index];

                return _CourseItem(courses!);
              },
            );
          }

          if (state is ErrorUserCoursesState)
            return Center(
              child: ErrorCustomWidget(
                onTap: () => BlocProvider.of<UserCoursesBloc>(context).add(LoadUserCoursesEvent()),
              ),
            );

          if (state is InitialUserCoursesState) {
            return LoaderWidget(
              loaderColor: ColorApp.mainColor,
            );
          }

          return Center(
            child: ErrorCustomWidget(
              onTap: () => BlocProvider.of<UserCoursesBloc>(context).add(LoadUserCoursesEvent()),
            ),
          );
        },
      ),
    );
  }

  void updateCompletedLesson() async {
    // Lessons Offline Mode
    final myList = recordMap;
    final jsonList = myList.map((item) => jsonEncode(item)).toList();
    final uniqueJsonList = jsonList.toSet().toList();
    final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();

    // Lessons Offline Mode
    if (_connectionStatus == ConnectivityResult.wifi || _connectionStatus == ConnectivityResult.mobile) {
      try {
        for (var el in result) {
          await _httpService.dio.put(
            '/course/lesson/complete',
            data: {'course_id': el['course_id'], 'item_id': el['lesson_id']},
            options: Options(
              headers: {'requirestoken': 'true'},
            ),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    result = await _connectivity.checkConnectivity();

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }
}

class _CourseItem extends StatelessWidget {
  const _CourseItem(
    this.postsBean, {
    key,
  }) : super(key: key);

  final PostsBean postsBean;

  String get category => postsBean.categoriesObject.isNotEmpty && postsBean.categoriesObject.first?.name != null
      ? postsBean.categoriesObject.first!.name
      : '';

  void openCourse(context) {
    Navigator.of(context)
        .pushNamed(
          UserCourseScreen.routeName,
          arguments: UserCourseScreenArgs.fromPostsBean(postsBean),
        )
        .then((value) => BlocProvider.of<UserCoursesBloc>(context).add(LoadUserCoursesEvent()));
  }

  @override
  Widget build(BuildContext context) {
    final double imgHeight = (MediaQuery.of(context).size.width > 450) ? 370.0 : 160.0;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
      child: Card(
        borderOnForeground: true,
        elevation: 2.5,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(0.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              onTap: () => openCourse(context),
              child: Hero(
                tag: postsBean.courseId,
                child: CachedNetworkImage(
                  imageUrl: postsBean.appImage,
                  placeholder: (ctx, url) => SizedBox(
                    height: imgHeight,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Visibility(
              visible: postsBean.fromCache ?? true,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    CategoryDetailScreen.routeName,
                    arguments: CategoryDetailScreenArgs(postsBean.categoriesObject.first),
                  ),
                  child: Text(
                    '${unescape.convert(category)} >',
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 16, color: Color(0xFF2a3045).withOpacity(0.5)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  UserCourseScreen.routeName,
                  arguments: UserCourseScreenArgs.fromPostsBean(postsBean),
                ),
                child: Text(
                  unescape.convert(postsBean.title),
                  textScaleFactor: 1.0,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 22,
                    color: ColorApp.dark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: postsBean.fromCache ?? true,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: SizedBox(
                    height: 6,
                    child: LinearProgressIndicator(
                      value: int.parse(postsBean.progress) / 100,
                      backgroundColor: Color(0xFFD7DAE2),
                      valueColor: AlwaysStoppedAnimation(ColorApp.secondaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: postsBean.fromCache ?? true,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      postsBean.duration ?? '',
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF2a3045).withOpacity(0.5)),
                    ),
                    Text(
                      postsBean.progressLabel ?? '',
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF2a3045).withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
            ),
            //Button 'CONTINUE'
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 16, right: 16, bottom: 16),
              child: MaterialButton(
                minWidth: double.infinity,
                color: ColorApp.secondaryColor,
                onPressed: () => openCourse(context),
                child: Text(
                  localizations.getLocalization('continue_button'),
                  textScaleFactor: 1.0,
                ),
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
