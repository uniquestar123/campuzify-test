import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/course/course_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/course_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/widgets/purchase_dialog.dart';
import 'package:masterstudy_app/presentation/screens/user_course/user_course.dart';
import 'package:masterstudy_app/presentation/widgets/alert_dialogs.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class BottomWidget extends StatefulWidget {
  const BottomWidget({
    Key? key,
    required this.coursesBean,
    this.optionsBean,
  }) : super(key: key);

  final CourseScreenArgs coursesBean;
  final OptionsBean? optionsBean;

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  String? selectedPlan = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseBloc, CourseState>(
      listener: (context, state) {
        if (state is SuccessGetTokenToCourseState) {
          launchUriMethod('${state.tokenAuth}&payment=pay');

          BlocProvider.of<CourseBloc>(context).add(FetchEvent(widget.coursesBean.id!));
        }
      },
      child: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is LoadedCourseState) {
            // If the course is free, then this function is executed
            if (state.courseDetailResponse.hasAccess!) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: ColorApp.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MaterialButton(
                    height: 45,
                    color: ColorApp.secondaryColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        UserCourseScreen.routeName,
                        arguments: UserCourseScreenArgs(
                          course_id: state.courseDetailResponse.id.toString(),
                          title: widget.coursesBean.title,
                          app_image: widget.coursesBean.images?.small,
                          avatar_url: state.courseDetailResponse.author?.avatarUrl,
                          login: state.courseDetailResponse.author?.login,
                          authorId: '0',
                          progress: '1',
                          lessonType: '',
                          lessonId: '',
                          isFirstStart: true,
                        ),
                      );
                    },
                    child: Text(
                      localizations.getLocalization('start_course_button'),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: ColorApp.white),
                    ),
                  ),
                ),
              );
            } else {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Price Course
                      buildPrice(state),
                      // Button "Get Now"
                      MaterialButton(
                        height: 40,
                        color: ColorApp.mainColor,
                        child: Text(state.courseDetailResponse.purchaseLabel!),
                        onPressed: () async {
                          if (!await isAuth()) {
                            showNotAuthorizedDialog(
                              context,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AuthScreen.routeName,
                                  arguments: AuthScreenArgs(
                                    optionsBean: widget.optionsBean,
                                  ),
                                );
                              },
                            );
                          } else {
                            if (BlocProvider.of<CourseBloc>(context).selectedPaymentId == -1) {
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                barrierColor: Colors.black.withAlpha(1),
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext _) {
                                  return Stack(
                                    children: <Widget>[
                                      Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.8),
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 25.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: IconButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Material(
                                              color: Colors.transparent,
                                              child: Center(
                                                child: Text(
                                                  localizations.getLocalization('in_app_info'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            Material(
                                              color: Colors.transparent,
                                              child: SizedBox(
                                                height: 45,
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: ColorApp.mainColor,
                                                  ),
                                                  onPressed: state is LoadingGetTokenToCourseState
                                                      ? null
                                                      : () => BlocProvider.of<CourseBloc>(context)
                                                          .add(GetTokenToCourse(widget.coursesBean.id!)),
                                                  child: state is LoadingGetTokenToCourseState
                                                      ? Center(
                                                          child: CircularProgressIndicator(),
                                                        )
                                                      : Text(
                                                          localizations.getLocalization('continue_button'),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            } else {
                              BlocProvider.of<CourseBloc>(context).add(UsePlan(state.courseDetailResponse.id));
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            }
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget buildPrice(CourseState state) {
    if (state is LoadedCourseState) {
      var userSubscriptions = state.userPlans?.subscriptions ?? [];

      if (!state.courseDetailResponse.hasAccess!) {
        if (state.courseDetailResponse.price?.free ?? false) {
          return GestureDetector(
            onTap: () async {
              if (await isAuth() == false) {
                showNotAuthorizedDialog(
                  context,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AuthScreen.routeName,
                      arguments: AuthScreenArgs(
                        optionsBean: widget.optionsBean,
                      ),
                    );
                  },
                );
              } else {
                await showDialog(
                  context: context,
                  builder: (builder) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return BlocProvider.value(
                          child: Dialog(
                            child: PurchaseDialog(),
                          ),
                          value: CourseBloc(),
                        );
                      },
                    );
                  },
                ).then((value) {
                  if (value == -1) {
                    BlocProvider.of<CourseBloc>(context).add(GetTokenToCourse(widget.coursesBean.id!));
                  } else {
                    setState(() {
                      selectedPlan = value;
                    });
                  }
                });
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  localizations.getLocalization('enroll_with_membership'),
                  textScaleFactor: 1.0,
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          );
        } else {
          // Set price for course
          if (BlocProvider.of<CourseBloc>(context).selectedPaymentId == -1) {
            selectedPlan =
                "${localizations.getLocalization("course_regular_price")} ${state.courseDetailResponse.price?.price}";
          }

          // If user have plans
          if (userSubscriptions.isNotEmpty) {
            userSubscriptions.forEach((value) {
              if (int.parse(value!.subscriptionId) == BlocProvider.of<CourseBloc>(context).selectedPaymentId) {
                selectedPlan = value.name;
              }
            });
          }

          return GestureDetector(
            onTap: () async {
              if (await isAuth() == false) {
                showNotAuthorizedDialog(
                  context,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AuthScreen.routeName,
                      arguments: AuthScreenArgs(
                        optionsBean: widget.optionsBean,
                      ),
                    );
                  },
                );
              } else {
                await showDialog(
                  context: context,
                  builder: (builder) {
                    return StatefulBuilder(
                      builder: (_, setState) {
                        return BlocProvider.value(
                          value: BlocProvider.of<CourseBloc>(context),
                          child: Dialog(
                            child: PurchaseDialog(),
                          ),
                        );
                      },
                    );
                  },
                ).then((value) {
                  if (value == -1) {
                    BlocProvider.of<CourseBloc>(context).add(GetTokenToCourse(widget.coursesBean.id!));
                  } else {
                    setState(() {
                      selectedPlan = value;
                    });
                  }
                });
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  selectedPlan!,
                  textScaleFactor: 1.0,
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          );
        }
      }
    }

    return const SizedBox();
  }
}
