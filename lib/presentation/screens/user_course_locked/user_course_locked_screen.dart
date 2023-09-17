import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/course/course_bloc.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/widgets/purchase_dialog.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/text_lesson/text_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/lesson_video_screen.dart';
import 'package:masterstudy_app/presentation/widgets/dialog_author.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';
import 'package:transparent_image/transparent_image.dart';

class UserCourseLockedScreenArgs {
  UserCourseLockedScreenArgs(this.courseId);

  final int courseId;
}

class UserCourseLockedScreen extends StatelessWidget {
  UserCourseLockedScreen() : super();

  static const String routeName = '/userCourseLockedScreen';

  @override
  Widget build(BuildContext context) {
    final UserCourseLockedScreenArgs args = ModalRoute.of(context)?.settings.arguments as UserCourseLockedScreenArgs;
    return UserCourseLockedWidget(args.courseId);
  }
}

class UserCourseLockedWidget extends StatefulWidget {
  const UserCourseLockedWidget(this.courseId) : super();
  final int courseId;

  @override
  State<StatefulWidget> createState() => UserCourseLockedWidgetState();
}

class UserCourseLockedWidgetState extends State<UserCourseLockedWidget> {
  late ScrollController _scrollController;
  String courseTitle = '';
  String title = '';

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (MediaQuery.of(context).size.height / 3 - (kToolbarHeight));
  }

  @override
  void initState() {
    BlocProvider.of<CourseBloc>(context).add(FetchEvent(widget.courseId));

    _scrollController = ScrollController()
      ..addListener(() {
        if (!_isAppBarExpanded) {
          setState(() {
            title = '';
          });
        } else {
          setState(() {
            title = courseTitle;
          });
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
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
                  expandedHeight: MediaQuery.of(context).size.height / 3.3,
                  floating: false,
                  pinned: true,
                  snap: false,
                  flexibleSpace: _buildFlexSpaceBar(state),
                )
              ];
            },
            body: Builder(
              builder: (context) {
                if (state is InitialCourseState) {
                  return LoaderWidget(
                    loaderColor: ColorApp.mainColor,
                  );
                }
                if (state is LoadedCourseState) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: SizedBox(
                            width: 48,
                            height: 61,
                            child: SvgPicture.asset(IconPath.lockColor),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(
                            localizations.getLocalization('trial_version_is_over'),
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(
                            localizations.getLocalization('trial_version_is_over_description'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Color(0xFFAAAAAA),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }

                return ErrorCustomWidget(
                  onTap: () => BlocProvider.of<CourseBloc>(context).add(FetchEvent(widget.courseId)),
                );
              },
            ),
          ),
          bottomNavigationBar: _buildBottom(state),
        );
      },
    );
  }

  _buildFlexSpaceBar(CourseState state) {
    if (state is LoadedCourseState) {
      courseTitle = state.courseDetailResponse.title;

      return FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          children: <Widget>[
            Hero(
              tag: state.courseDetailResponse.id,
              child: FadeInImage.memoryNetwork(
                image: state.courseDetailResponse.images!.full!,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.3 + MediaQuery.of(context).padding.top,
                placeholder: kTransparentImage,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2A3045).withOpacity(0.7),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3.3,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) => DialogAuthorWidget(state),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    state.courseDetailResponse.author!.avatarUrl!,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: 55,
                            child: Text(
                              state.courseDetailResponse.title,
                              textScaleFactor: 1.0,
                              style: TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: SizedBox(
                              height: 6,
                              child: LinearProgressIndicator(
                                value: 0,
                                backgroundColor: Color(0xFFD7DAE2),
                                valueColor: AlwaysStoppedAnimation(ColorApp.secondaryColor),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            color: ColorApp.secondaryColor,
                            onPressed: null,
                            child: Text(
                              localizations.getLocalization('continue_button'),
                              textScaleFactor: 1.0,
                            ),
                            textColor: Colors.white,
                            disabledColor: ColorApp.secondaryColor.withOpacity(0.5),
                            disabledTextColor: Colors.white.withOpacity(0.6),
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
      );
    }
  }

  _buildBottom(CourseState state) {
    // Если курс приобретен и у пользователя есть доступ
    if (state is LoadedCourseState && state.courseDetailResponse.hasAccess!) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: kButtonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.secondaryColor,
              ),
              onPressed: () {
                switch (state.courseDetailResponse.firstLessonType) {
                  case 'video':
                    Navigator.of(context).pushReplacementNamed(
                      LessonVideoScreen.routeName,
                      arguments: LessonVideoScreenArgs(
                        state.courseDetailResponse.id,
                        state.courseDetailResponse.firstLesson,
                        state.courseDetailResponse.author!.avatarUrl!,
                        state.courseDetailResponse.author!.login,
                        true,
                        state.courseDetailResponse.trial,
                      ),
                    );
                    break;
                  default:
                    Navigator.of(context).pushReplacementNamed(
                      TextLessonScreen.routeName,
                      arguments: TextLessonScreenArgs(
                        state.courseDetailResponse.id,
                        state.courseDetailResponse.firstLesson,
                        state.courseDetailResponse.author!.avatarUrl!,
                        state.courseDetailResponse.author!.login,
                        true,
                        state.courseDetailResponse.trial,
                      ),
                    );
                }
              },
              child: Text(
                localizations.getLocalization('start_course_button'),
                style: TextStyle(color: ColorApp.white),
              ),
            ),
          ),
        ),
      );
    }

    // Если у пользователя не приобретен курс
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildPrice(state),
            MaterialButton(
              height: 40,
              color: ColorApp.mainColor,
              onPressed: () {
                if (state is LoadedCourseState) {
                  if (!state.courseDetailResponse.hasAccess!) {
                    if (BlocProvider.of<CourseBloc>(context).selectedPaymentId == -1) {
                      BlocProvider.of<CourseBloc>(context).add(AddToCart(state.courseDetailResponse.id));
                    } else {
                      BlocProvider.of<CourseBloc>(context).add(UsePlan(state.courseDetailResponse.id));
                    }
                  }
                }
              },
              child: setUpButtonChild(state),
            )
          ],
        ),
      ),
    );
  }

  _buildPrice(CourseState state) {
    if (state is LoadedCourseState) {
      if (!state.courseDetailResponse.hasAccess!) {
        if (state.courseDetailResponse.price?.free ?? false) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                localizations.getLocalization('course_free_price'),
                textScaleFactor: 1.0,
              ),
              Icon(Icons.arrow_drop_down)
            ],
          );
        } else {
          String? selectedPlan;
          if (BlocProvider.of<CourseBloc>(context).selectedPaymentId == -1)
            selectedPlan =
                "${localizations.getLocalization("course_regular_price")} ${state.courseDetailResponse.price?.price}";
          if (state.userPlans!.subscriptions.isNotEmpty) {
            state.userPlans!.subscriptions.forEach((value) {
              if (int.parse(value!.id) == BlocProvider.of<CourseBloc>(context).selectedPaymentId)
                selectedPlan = value.name;
            });
          }
          return GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (builder) {
                  return BlocProvider.value(
                    value: BlocProvider.of<CourseBloc>(context),
                    child: Dialog(
                      child: PurchaseDialog(),
                    ),
                  );
                },
              );
              setState(() {});
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  selectedPlan!,
                  textScaleFactor: 1.0,
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          );
        }
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[],
        );
      }
    }
    return const SizedBox();
  }

  Widget setUpButtonChild(CourseState state) {
    String? buttonText;
    bool enable = state is LoadedCourseState;

    if (state is LoadedCourseState) {
      buttonText = state.courseDetailResponse.purchaseLabel;
    }

    if (enable == true) {
      return Text(
        buttonText!.toUpperCase(),
        textScaleFactor: 1.0,
      );
    } else {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      );
    }
  }
}
