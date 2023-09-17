import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/extensions/color_extensions.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/course/course_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/user_course_locked/user_course_locked_bloc.dart';
import 'package:masterstudy_app/presentation/screens/detail_profile/detail_profile_screen.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogAuthorWidget extends StatelessWidget {
  DialogAuthorWidget(this.courseState);

  final CourseState courseState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 15.0, left: 20.0, right: 20.0),
                child: buildBody(context, courseState),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, dynamic state) {
    if (state is LoadedCourseState || state is LoadedUserCourseLockedState) {
      var authorName = state.courseDetailResponse.author.login;
      if (state.courseDetailResponse.author.meta.firstName != null) {
        authorName = state.courseDetailResponse.author.meta.firstName;
        if (state.courseDetailResponse.author.meta.lastName != null) {
          authorName = authorName + ' ' + state.courseDetailResponse.author.meta.lastName;
        }
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      state.courseDetailResponse.author.meta.position ?? '',
                      textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500, color: HexColor.fromHex('#AAAAAA')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        authorName,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: HexColor.fromHex('#273044'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: <Widget>[
                          RatingBar.builder(
                            initialRating: state.courseDetailResponse.author.rating.average.toDouble(),
                            minRating: 0,
                            direction: Axis.horizontal,
                            tapOnlyMode: true,
                            glow: false,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            unratedColor: HexColor.fromHex('#CCCCCC'),
                            itemCount: 5,
                            itemSize: 19,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (kDebugMode) {
                                print(rating);
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '${state.courseDetailResponse.author.rating.average.toDouble()}',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: HexColor.fromHex('#273044'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              state.courseDetailResponse.author.rating.totalMarks == null
                                  ? ''
                                  : '(${state.courseDetailResponse.author.rating.totalMarks})',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: HexColor.fromHex('#AAAAAA'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(state.courseDetailResponse.author.avatarUrl),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          if (preferences.getString(PreferencesName.apiToken) == null ||
              preferences.getString(PreferencesName.apiToken)!.isEmpty)
            const SizedBox()
          else
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  //Author info
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: MaterialButton(
                      height: 36,
                      color: ColorApp.mainColor,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        DetailProfileScreen.routeName,
                        arguments: DetailProfileScreenArgs.fromId(teacherId: state.courseDetailResponse.author.id),
                      ),
                      child: Text(
                        localizations.getLocalization('profile_button'),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ),
                  //Facebook
                  Visibility(
                    visible: state.courseDetailResponse.author.meta.facebookIcon != null &&
                        state.courseDetailResponse.author.meta.facebookIcon != '',
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 5.0),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            if (await canLaunchUrl(Uri.parse(state.courseDetailResponse.author.meta.facebookIcon))) {
                              await launchUrl(Uri.parse(state.courseDetailResponse.author.meta.facebookIcon));
                            } else {
                              await launchUrl(Uri.parse('https://www.facebook.com/'));
                            }
                          } catch (e) {
                            await launchUrl(Uri.parse('https://www.facebook.com/'));
                          }
                        },
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: Image(
                            image: AssetImage(IconPath.facebookIcon),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Twitter
                  Visibility(
                    visible: state.courseDetailResponse.author.meta.twitterIcon != null &&
                        state.courseDetailResponse.author.meta.twitterIcon != '',
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            if (await canLaunchUrl(Uri.parse(state.courseDetailResponse.author.meta.twitterIcon))) {
                              await launchUrl(Uri.parse(state.courseDetailResponse.author.meta.twitterIcon));
                            } else {
                              await launchUrl(Uri.parse('https://www.twitter.com/'));
                            }
                          } catch (e) {
                            await launchUrl(Uri.parse('https://www.twitter.com/'));
                          }
                        },
                        child: SizedBox(width: 36, height: 36, child: Image(image: AssetImage(IconPath.twitterIcon))),
                      ),
                    ),
                  ),
                  //Instagram
                  Visibility(
                    visible: state.courseDetailResponse.author.meta.instagramIcon != null &&
                        state.courseDetailResponse.author.meta.instagramIcon != '',
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            if (await canLaunchUrl(Uri.parse(state.courseDetailResponse.author.meta.instagramIcon))) {
                              await launchUrl(Uri.parse(state.courseDetailResponse.author.meta.instagramIcon));
                            } else {
                              await launchUrl(Uri.parse('https://www.instagram.com/'));
                            }
                          } catch (e) {
                            await launchUrl(Uri.parse('https://www.instagram.com/'));
                          }
                        },
                        child: SizedBox(width: 36, height: 36, child: Image(image: AssetImage(IconPath.instagramIcon))),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      );
    }

    return Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }
}

void showDialogError(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          localizations.getLocalization('warning'),
          textScaleFactor: 1.0,
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        content: Text(text, textScaleFactor: 1.0),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.mainColor,
            ),
            child: Text(
              localizations.getLocalization('ok_dialog_button'),
              textScaleFactor: 1.0,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
