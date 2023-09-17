import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/extensions/color_extensions.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/user_course/user_course_bloc.dart';
import 'package:masterstudy_app/presentation/screens/detail_profile/detail_profile_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/quiz_lesson/quiz_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/text_lesson/text_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/lesson_video_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/zoom_lesson/zoom.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class UserCourseScreenArgs {
  UserCourseScreenArgs({
    this.course_id,
    this.title,
    this.app_image,
    this.avatar_url,
    this.login,
    this.authorId,
    this.progress,
    required this.lessonType,
    required this.lessonId,
    this.isFirstStart,
  }) : postsBean = PostsBean(
          courseId: course_id,
          title: title,
          appImage: app_image,
          progress: progress,
          lessonType: lessonType,
          lessonId: lessonId,
          categoriesObject: [],
          author: PostAuthorBean(
            id: authorId,
            avatarUrl: avatar_url,
            login: '',
            url: '',
            meta: null,
          ),
          termsList: [],
          progressLabel: null,
          startTime: null,
          salePrice: null,
          terms: [],
          link: null,
          price: null,
          duration: null,
          postStatus: null,
          imageId: null,
          hash: '',
          views: null,
          fromCache: false,
          image: null,
          currentLessonId: null,
        );

  UserCourseScreenArgs.fromPostsBean(PostsBean postsBean)
      : course_id = postsBean.courseId,
        title = postsBean.title,
        app_image = postsBean.appImage,
        avatar_url = postsBean.author?.avatarUrl,
        login = postsBean.author?.login,
        authorId = postsBean.author?.id,
        progress = postsBean.progress,
        lessonType = postsBean.lessonType ?? '',
        lessonId = postsBean.lessonId,
        hash = postsBean.hash,
        postsBean = postsBean;

  final String? course_id;
  final String? title;
  final String? app_image;
  final String? avatar_url;
  final String? login;
  final String? authorId;
  final String? progress;
  String? lessonType;
  String? lessonId;
  String? hash;
  PostsBean? postsBean;
  dynamic isFirstStart;
}

class UserCourseScreen extends StatelessWidget {
  static const String routeName = '/userCourseScreen';

  @override
  Widget build(BuildContext context) {
    final UserCourseScreenArgs args = ModalRoute.of(context)?.settings.arguments as UserCourseScreenArgs;

    return BlocProvider(
      create: (context) => UserCourseBloc(),
      child: UserCourseWidget(args),
    );
  }
}

class UserCourseWidget extends StatefulWidget {
  const UserCourseWidget(this.args) : super();

  final UserCourseScreenArgs args;

  @override
  State<StatefulWidget> createState() => UserCourseWidgetState();
}

class UserCourseWidgetState extends State<UserCourseWidget> {
  late ScrollController _scrollController;
  String title = '';

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (MediaQuery.of(context).size.height / 3 - (kToolbarHeight));
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void initState() {
    _enableRotation();

    BlocProvider.of<UserCourseBloc>(context).add(FetchEvent(widget.args));

    _scrollController = ScrollController()
      ..addListener(() {
        if (!_isAppBarExpanded) {
          setState(() {
            title = '';
          });
        } else {
          setState(() {
            title = unescape.convert(widget.args.title!);
          });
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    num kef = (MediaQuery.of(context).size.height > 690) ? 3.3 : 3;

    return BlocBuilder<UserCourseBloc, UserCourseState>(
      builder: (context, state) {
        return Scaffold(
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: ColorApp.mainColor,
                  title: Text(
                    title,
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  expandedHeight: MediaQuery.of(context).size.height / kef,
                  floating: false,
                  pinned: true,
                  snap: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      children: <Widget>[
                        // Background Img AppBar
                        Hero(
                          tag: widget.args.course_id ?? 0,
                          child: CachedNetworkImage(
                            imageUrl: widget.args.app_image ??
                                'http://ms.stylemix.biz/wp-content/uploads/elementor/thumbs/placeholder-1919x1279-plpkge6q8d1n11vbq6ckurd53ap3zw1gbw0n5fqs0o.gif',
                            placeholder: (ctx, url) => SizedBox(
                              height: MediaQuery.of(context).size.height / 3 + MediaQuery.of(context).padding.top,
                            ),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 3 + MediaQuery.of(context).padding.top,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Color for Background
                        Container(
                          decoration: BoxDecoration(color: Color(0xFF2A3045).withOpacity(0.7)),
                        ),
                        // Info in AppBar
                        Container(
                          height: MediaQuery.of(context).size.height / kef,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // User/Teacher/Student Profile
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              if (state is LoadedUserCourseState) {
                                                Navigator.pushNamed(
                                                  context,
                                                  DetailProfileScreen.routeName,
                                                  arguments: DetailProfileScreenArgs.fromId(
                                                    teacherId: int.parse(widget.args.authorId ?? ''),
                                                  ),
                                                );
                                              }
                                            },
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                (state is LoadedUserCourseState)
                                                    ? widget.args.avatar_url!
                                                    : 'http://ms.stylemix.biz/wp-content/uploads/elementor/thumbs/placeholder-1919x1279-plpkge6q8d1n11vbq6ckurd53ap3zw1gbw0n5fqs0o.gif',
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // Title
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        height: 55,
                                        child: Text(
                                          unescape.convert(widget.args.title!),
                                          textScaleFactor: 1.0,
                                          style: TextStyle(color: Colors.white, fontSize: 24),
                                        ),
                                      ),
                                    ),
                                    // ProgressIndicator
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        child: SizedBox(
                                          height: 6,
                                          child: LinearProgressIndicator(
                                            value: int.parse(
                                                  state is LoadedUserCourseState ? state.progress ?? '' : '0',
                                                ) /
                                                100,
                                            backgroundColor: Color(0xFFD7DAE2),
                                            valueColor: AlwaysStoppedAnimation(ColorApp.secondaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Button "Continue" and icon "Download"
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          // Button "Continue"
                                          Expanded(
                                            flex: 5,
                                            child: MaterialButton(
                                              minWidth: double.infinity,
                                              color: ColorApp.secondaryColor,
                                              onPressed: () {
                                                bool containsLastLesson = false;
                                                int? lessonId;
                                                String? lessonType;

                                                if (state is LoadedUserCourseState) {
                                                  if (state.response?.materials != null &&
                                                      state.response!.materials.isNotEmpty) {
                                                    MaterialItem? notCompletedCurriculum = state.response!.materials
                                                        .firstWhere((element) => !element.completed);

                                                    setState(() {
                                                      containsLastLesson = true;
                                                      lessonId = notCompletedCurriculum.postId;
                                                      lessonType = notCompletedCurriculum.type;
                                                    });

                                                    if (containsLastLesson) {
                                                      if (lessonId != null) {
                                                        _openLesson(lessonType, lessonId!);
                                                      }
                                                    }
                                                  }
                                                }
                                              },
                                              child: Text(
                                                localizations.getLocalization('continue_button'),
                                                textScaleFactor: 1.0,
                                              ),
                                              textColor: Colors.white,
                                            ),
                                          ),
                                          // Icon "Download"
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20.0),
                                            child: _buildCacheButton(state),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ];
            },
            body: Builder(
              builder: (BuildContext context) {
                if (state is InitialUserCourseState) {
                  return LoaderWidget(
                    loaderColor: ColorApp.mainColor,
                  );
                }

                if (state is LoadedUserCourseState) {
                  widget.args.lessonId = state.response!.currentLessonId!;
                  widget.args.lessonType = state.response!.lessonType!;

                  if (state.sections.isEmpty) {
                    return EmptyWidget(
                      iconData: IconPath.emptyCourses,
                      title: localizations.getLocalization('empty_sections_course'),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.sections.length,
                    itemBuilder: (context, index) {
                      final sectionItem = state.sections[index]!;
                      List<MaterialItem?> filteredList =
                          state.materials.where((element) => element!.sectionId == sectionItem.id).toList();

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '${localizations.getLocalization('section')} ${sectionItem.order}',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(color: Color(0xFFAAAAAA)),
                                ),
                                Text(
                                  sectionItem.title ?? '',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    color: Color(0xFF273044),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (state.materials.isNotEmpty)
                            Column(
                              children: filteredList.map((value) {
                                return _buildLesson(value!);
                              }).toList(),
                            )
                          else
                            const SizedBox(),
                        ],
                      );
                    },
                  );
                }

                if (state is ErrorUserCourseState) {
                  return Center(
                    child: ErrorCustomWidget(
                      onTap: () => BlocProvider.of<UserCourseBloc>(context).add(FetchEvent(widget.args)),
                    ),
                  );
                }

                return Center(
                  child: ErrorCustomWidget(
                    onTap: () => BlocProvider.of<UserCourseBloc>(context).add(FetchEvent(widget.args)),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Method for download lessons
  _buildCacheButton(state) {
    if (state is LoadedUserCourseState) {
      Widget icon;
      if (state.isCached!) {
        icon = Icon(
          Icons.check,
          color: Colors.white,
        );
      } else if (state.showCachingProgress!) {
        icon = LoaderWidget();
      } else {
        icon = Icon(
          Icons.cloud_download,
          color: Colors.white,
        );
      }

      return widget.args.isFirstStart == true
          ? SizedBox()
          : InkWell(
              onTap: () {
                if (!state.showCachingProgress! && !state.isCached!) {
                  BlocProvider.of<UserCourseBloc>(context).add(CacheCourseEvent(widget.args));
                }
              },
              child: CircleAvatar(
                backgroundColor: ColorApp.mainColor,
                radius: 25.0,
                child: icon,
              ),
            );
    } else {
      return SizedBox(width: 50, height: 50);
    }
  }

  ///Widget: Icon type lesson, and title lesson
  Widget _buildLesson(MaterialItem materialItem) {
    bool locked = materialItem.locked && dripContentEnabled;
    String? duration = materialItem.duration ?? '';
    Widget icon = const SizedBox();

    switch (materialItem.type) {
      case 'video':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.play,
            color: (!locked) ? ColorApp.mainColor : HexColor.fromHex('#2A3045').withOpacity(0.3),
          ),
        );
        break;
      case 'stream':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.videoCamera,
            color: (!locked) ? ColorApp.mainColor : HexColor.fromHex('#2A3045').withOpacity(0.3),
          ),
        );
        break;
      case 'slide':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.slides,
            color: (!locked) ? ColorApp.mainColor : HexColor.fromHex('#2A3045').withOpacity(0.3),
          ),
        );
        break;
      case 'assignment':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.assignment,
            color: (!locked) ? ColorApp.mainColor : HexColor.fromHex('#2A3045').withOpacity(0.3),
          ),
        );
        break;
      case 'quiz':
        duration = materialItem.questions;
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.question,
            color: (!locked) ? ColorApp.mainColor : HexColor.fromHex('#2A3045').withOpacity(0.3),
          ),
        );
        break;
      case 'text':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.text,
            color: (!locked) ? ColorApp.mainColor : HexColor.fromHex('#2A3045').withOpacity(0.3),
          ),
        );
        break;
      case 'lesson':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.text,
            color: (!locked) ? ColorApp.mainColor : HexColor.fromHex('#2A3045').withOpacity(0.3),
          ),
        );
        break;
      case 'zoom_conference':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.zoom,
          ),
        );
        break;
      case '':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.text,
            color: (!locked) ? ColorApp.mainColor : HexColor.fromHex('#2A3045').withOpacity(0.3),
          ),
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: InkWell(
        onTap: () {
          if (!locked) _openLesson(materialItem.type, materialItem.postId);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(color: Color(0xFFF3F5F9)),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //Icon and Title of Lesson
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Icon Type of Lesson
                      icon,
                      // Title Lesson
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            materialItem.title,
                            textScaleFactor: 1.0,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(color: locked ? Colors.black.withOpacity(0.3) : Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //Icon 'Замок' и 'Время и текст'
                Stack(
                  children: <Widget>[
                    //Icon "Замок" если курс не куплен
                    Visibility(
                      visible: locked,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset(
                          IconPath.lock,
                          color: ColorApp.mainColor,
                        ),
                      ),
                    ),
                    //Icon "Время" и время курса (Duration)
                    Visibility(
                      visible: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Icon 'Время'
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: SvgPicture.asset(IconPath.durationCurriculum),
                          ),
                          //Text
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              duration!,
                              textScaleFactor: 1.0,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black.withOpacity(0.3)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Open Lesson
  _openLesson(String? type, int id) {
    Future screenFuture;
    switch (type) {
      case 'quiz':
        screenFuture = Navigator.of(context).pushNamed(
          QuizLessonScreen.routeName,
          arguments:
              QuizLessonScreenArgs(int.parse(widget.args.course_id!), id, widget.args.avatar_url!, widget.args.login!),
        );
        break;
      case 'text':
        screenFuture = Navigator.of(context).pushNamed(
          TextLessonScreen.routeName,
          arguments: TextLessonScreenArgs(
            int.parse(widget.args.course_id!),
            id,
            widget.args.avatar_url!,
            widget.args.login!,
            false,
            true,
          ),
        );
        break;
      case 'video':
        screenFuture = Navigator.of(context).pushNamed(
          LessonVideoScreen.routeName,
          arguments: LessonVideoScreenArgs(
            int.tryParse(widget.args.course_id!)!,
            id,
            widget.args.avatar_url!,
            widget.args.login!,
            false,
            true,
          ),
        );
        break;
      case 'assignment':
        screenFuture = Navigator.of(context).pushNamed(
          AssignmentScreen.routeName,
          arguments: AssignmentScreenArgs(
            int.tryParse(widget.args.course_id!)!,
            id,
            widget.args.avatar_url!,
            widget.args.login!,
          ),
        );
        break;
      case 'zoom_conference':
        screenFuture = Navigator.of(context).pushNamed(
          LessonZoomScreen.routeName,
          arguments: LessonZoomScreenArgs(
            int.tryParse(widget.args.course_id!)!,
            id,
            widget.args.avatar_url!,
            widget.args.login!,
            false,
            true,
          ),
        );
        break;
      default:
        screenFuture = Navigator.of(context).pushNamed(
          TextLessonScreen.routeName,
          arguments: TextLessonScreenArgs(
            int.tryParse(widget.args.course_id!)!,
            id,
            widget.args.avatar_url!,
            widget.args.login!,
            false,
            true,
          ),
        );
    }
    screenFuture.then((value) => {BlocProvider.of<UserCourseBloc>(context).add(FetchEvent(widget.args))});
  }
}
