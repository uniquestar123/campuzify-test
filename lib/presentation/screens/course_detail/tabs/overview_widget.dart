import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/data/models/review/review_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/meta_icon.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/tabs/widgets/annoncement_card.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/tabs/widgets/description_card.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/tabs/widgets/reviews_stat_card.dart';
import 'package:masterstudy_app/presentation/screens/review_write/review_write_screen.dart';
import 'package:masterstudy_app/presentation/widgets/dialog_author.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class OverviewWidget extends StatefulWidget {
  const OverviewWidget(
    this.response,
    this.reviewResponse,
    this.scrollCallback,
    this.optionsBean,
  ) : super();

  final CourseDetailResponse response;
  final ReviewResponse reviewResponse;
  final VoidCallback scrollCallback;
  final OptionsBean optionsBean;

  @override
  State<StatefulWidget> createState() => _OverviewWidgetState();
}

class _OverviewWidgetState extends State<OverviewWidget> with AutomaticKeepAliveClientMixin {
  int reviewsListShowItems = 1;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            // Description
            DescriptionCard(
              descriptionUrl: widget.response.description!,
              scrollCallback: widget.scrollCallback,
            ),
            // Meta
            Column(
              children: widget.response.meta.map((value) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              MetaIcon(
                                value!.type,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  value.label,
                                  textScaleFactor: 1.0,
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Text(
                              value.text ?? '',
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      height: 2,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                );
              }).toList(),
            ),
            // Annoncement
            AnnoncementCard(annoncementUrl: widget.response.announcement),
            // ReviewsStat
            ReviewsStatCard(rating: widget.response.rating!),
            // Write a review button
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                minWidth: double.infinity,
                color: ColorApp.mainColor,
                onPressed: () async {
                  if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                    showDialogError(context, localizations.getLocalization('demo_mode'));
                  } else if (await isAuth() == false) {
                    showDialogError(context, localizations.getLocalization('not_authenticated'));
                  } else {
                    Navigator.of(context).pushNamed(
                      ReviewWriteScreen.routeName,
                      arguments: ReviewWriteScreenArgs(
                        widget.response.id,
                        widget.response.title,
                        optionsBean: widget.optionsBean,
                      ),
                    );
                  }
                },
                child: Text(
                  localizations.getLocalization('write_review_button'),
                  textScaleFactor: 1.0,
                ),
                textColor: Colors.white,
              ),
            ),
            _buildReviewList(widget.reviewResponse.posts),
          ],
        ),
      ),
    );
  }

  _buildReviewList(List<ReviewBean?> reviews) {
    if (reviews.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: reviewsListShowItems,
          itemBuilder: (context, index) {
            var item = reviews[index];
            return _buildReviewItem(item!);
          },
        ),
        (reviews.length != 1)
            ? InkWell(
                onTap: () {
                  setState(() {
                    reviewsListShowItems == 1 ? reviewsListShowItems = reviews.length : reviewsListShowItems = 1;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    reviewsListShowItems != 1
                        ? localizations.getLocalization('show_less_button')
                        : localizations.getLocalization('show_more_button'),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: ColorApp.mainColor),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  _buildReviewItem(ReviewBean review) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color(0xFFEEF1F7),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            review.user,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF273044),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            review.time,
                            textScaleFactor: 1.0,
                            style: TextStyle(fontSize: 14.0, color: Color(0xFFAAAAAA)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RatingBar.builder(
                          initialRating: review.mark.toDouble(),
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemSize: 19,
                          unratedColor: Color(0xFFCCCCCC),
                          itemBuilder: (context, index) {
                            return Icon(
                              Icons.star,
                              color: Colors.amber,
                            );
                          },
                          onRatingUpdate: (double value) {},
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Html(data: review.content),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
