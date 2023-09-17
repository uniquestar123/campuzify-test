import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/category/category.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/screens/category_detail/category_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/course_detail_screen.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class TrendingWidget extends StatelessWidget {
  TrendingWidget(
    this.darkMode,
    this.title,
    this.courses,
    this.optionsBean, {
    Key? key,
  }) : super(key: key);

  final bool darkMode;
  final String? title;
  final List<CoursesBean?> courses;
  final OptionsBean? optionsBean;

  Color get backgroundColor => darkMode ? ColorApp.dark : Colors.white;

  Color get primaryTextColor => darkMode ? ColorApp.white : ColorApp.dark;

  Color? get secondaryTextColor => darkMode ? ColorApp.white.withOpacity(0.5) : Colors.grey[500];

  @override
  Widget build(BuildContext context) {
    return (courses.length != 0)
        ? DecoratedBox(
            decoration: BoxDecoration(color: backgroundColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 30.0, bottom: 20),
                  child: Text(
                    localizations.getLocalization('trending_courses'),
                    textScaleFactor: 1.0,
                    style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                          color: primaryTextColor,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    itemCount: courses.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      double leftPadding = (index == 0) ? 30 : 8;

                      final item = courses[index];

                      num? rating = 0.0;
                      num? reviews = 0;

                      if (item!.rating != null) {
                        if (item.rating?.total != null) {
                          rating = item.rating?.average?.toDouble();
                        }
                        if (item.rating?.total != null) {
                          reviews = item.rating?.total;
                        }
                      }

                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          CourseScreen.routeName,
                          arguments: CourseScreenArgs.fromCourseBean(
                            item,
                            optionsBean: optionsBean,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: leftPadding),
                          child: TrendingCourseItem(
                            image: item.images?.small!,
                            category: item.categoriesObject,
                            title: item.title,
                            stars: double.parse(rating.toString()),
                            reviews: double.parse(reviews.toString()),
                            price: item.price?.price,
                            oldPrice: item.price?.oldPrice,
                            free: item.price?.free,
                            optionsBean: optionsBean,
                            darkMode: darkMode,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class TrendingCourseItem extends StatelessWidget {
  const TrendingCourseItem({
    Key? key,
    required this.image,
    this.category,
    required this.title,
    required this.stars,
    required this.reviews,
    required this.price,
    required this.oldPrice,
    required this.free,
    required this.optionsBean,
    required this.darkMode,
  }) : super(key: key);

  final String? image;
  final List<Category?>? category;
  final String? title;
  final double stars;
  final double reviews;
  final String? price;
  final String? oldPrice;
  final bool? free;
  final OptionsBean? optionsBean;
  final bool darkMode;

  String get categoryName =>
      (category != null && category!.isNotEmpty) ? "${unescape.convert(category!.first?.name ?? "")} >" : '';

  Color get backgroundColor => darkMode ? ColorApp.dark : Colors.white;

  Color get primaryTextColor => darkMode ? ColorApp.white : ColorApp.dark;

  Color? get secondaryTextColor => darkMode ? ColorApp.white.withOpacity(0.5) : Colors.grey[500];

  @override
  Widget build(BuildContext context) {
    Widget buildPrice;

    if (free!) {
      buildPrice = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          localizations.getLocalization('course_free_price'),
          textScaleFactor: 1.0,
          style: Theme.of(context)
              .primaryTextTheme
              .titleMedium
              ?.copyWith(color: primaryTextColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      buildPrice = Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 0.0, right: 16.0),
        child: Row(
          children: <Widget>[
            Text(
              price!,
              textScaleFactor: 1.0,
              style: Theme.of(context)
                  .primaryTextTheme
                  .titleMedium
                  ?.copyWith(color: primaryTextColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
            ),
            Visibility(
              visible: oldPrice != null,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  oldPrice.toString(),
                  textScaleFactor: 1.0,
                  style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                        color: secondaryTextColor,
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.network(
            image!,
            fit: BoxFit.cover,
            width: 160,
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 0.0, right: 16.0),
            child: GestureDetector(
              onTap: () {
                if (category != null && category!.isNotEmpty)
                  Navigator.pushNamed(
                    context,
                    CategoryDetailScreen.routeName,
                    arguments: CategoryDetailScreenArgs(
                      category!.first,
                      optionsBean: optionsBean,
                    ),
                  );
              },
              child: Text(
                categoryName,
                textScaleFactor: 1.0,
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      color: secondaryTextColor,
                      fontStyle: FontStyle.normal,
                      fontSize: 12,
                    ),
              ),
            ),
          ),
          Container(
            height: 32,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 0.0, right: 16.0),
              child: Text(
                unescape.convert(title ?? ''),
                textScaleFactor: 1.0,
                maxLines: 2,
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      color: primaryTextColor,
                      fontStyle: FontStyle.normal,
                      fontSize: 12,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 0.0, right: 16.0),
            child: Row(
              children: <Widget>[
                RatingBar.builder(
                  initialRating: stars,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  ignoreGestures: true,
                  itemCount: 5,
                  itemSize: 16,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  glow: false,
                  onRatingUpdate: (double value) {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    '$stars ($reviews)',
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 16, color: primaryTextColor),
                  ),
                ),
              ],
            ),
          ),
          buildPrice,
        ],
      ),
    );
  }
}
