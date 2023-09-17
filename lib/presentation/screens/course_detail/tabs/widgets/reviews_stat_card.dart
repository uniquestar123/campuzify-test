import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class ReviewsStatCard extends StatefulWidget {
  const ReviewsStatCard({Key? key, required this.rating}) : super(key: key);

  final RatingBean rating;

  @override
  State<ReviewsStatCard> createState() => _ReviewsStatCardState();
}

class _ReviewsStatCardState extends State<ReviewsStatCard> {
  @override
  Widget build(BuildContext context) {
    int total = widget.rating.total;
    final onePercent = total / 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Text(
            localizations.getLocalization('reviews_title'),
            textScaleFactor: 1.0,
            style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                  color: ColorApp.dark,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                StatRowCard('5', widget.rating.details!.five / onePercent, widget.rating.details!.five.toString()),
                StatRowCard('4', widget.rating.details!.four / onePercent, widget.rating.details!.four.toString()),
                StatRowCard('3', widget.rating.details!.three / onePercent, widget.rating.details!.three.toString()),
                StatRowCard('2', widget.rating.details!.two / onePercent, widget.rating.details!.two.toString()),
                StatRowCard('1', widget.rating.details!.one / onePercent, widget.rating.details!.one.toString()),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 140,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color(0xFFEEF1F7),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.rating.average!.toDouble().toString().substring(0, 3),
                        textScaleFactor: 1.0,
                        style: TextStyle(fontSize: 50),
                      ),
                      RatingBar.builder(
                        initialRating: widget.rating.average!.toDouble(),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 19,
                        unratedColor: Color(0xFFCCCCCC),
                        itemBuilder: (context, index) {
                          return Icon(
                            Icons.star,
                            color: Colors.amber,
                          );
                        },
                        onRatingUpdate: (rating) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "(${widget.rating.total} ${localizations.getLocalization("reviews_count")})",
                          style: TextStyle(
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}

class StatRowCard extends StatelessWidget {
  const StatRowCard(
    this.stars,
    this.progress,
    this.count, {
    Key? key,
  }) : super(key: key);

  final String stars;
  final double progress;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "$stars ${localizations.getLocalization("stars_count")}",
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Color(0xFF777777),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: SizedBox(
                width: 105,
                height: 15,
                child: LinearProgressIndicator(
                  value: (!progress.isNaN) ? progress / 100 : 0,
                  backgroundColor: Color(0xFFF3F5F9),
                  valueColor: AlwaysStoppedAnimation(Color(0xFFECA824)),
                ),
              ),
            ),
          ),
          Text(
            count,
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Color(0xFF777777),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
