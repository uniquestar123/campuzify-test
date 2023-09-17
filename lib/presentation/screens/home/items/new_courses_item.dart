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

class NewCoursesWidget extends StatelessWidget {
  NewCoursesWidget(this.title, this.courses, this.optionsBean, {Key? key}) : super(key: key);

  final String? title;
  final List<CoursesBean?> courses;
  final OptionsBean? optionsBean;

  @override
  Widget build(BuildContext context) {
    return courses.length != 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 30.0, bottom: 20),
                child: Text(
                  localizations.getLocalization('new_courses'),
                  textScaleFactor: 1.0,
                  style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                        color: ColorApp.dark,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFeef1f7)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 370, maxHeight: 390),
                    child: ListView.builder(
                      itemCount: courses.length,
                      padding: const EdgeInsets.all(8.0),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var item = courses[index];
                        var padding = (index == 0) ? 20.0 : 0.0;

                        double? rating = 0.0;
                        num? reviews = 0;
                        rating = item?.rating?.average?.toDouble();
                        reviews = item?.rating?.total;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              CourseScreen.routeName,
                              arguments: CourseScreenArgs.fromCourseBean(
                                item,
                                optionsBean: optionsBean,
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: padding),
                            child: CourseCard(
                              image: item?.images?.small,
                              category: item!.categoriesObject.isNotEmpty ? item.categoriesObject.first : null,
                              title: item.title,
                              stars: rating,
                              reviews: reviews,
                              price: item.price?.price,
                              oldPrice: item.price?.oldPrice,
                              free: item.price?.free,
                              status: item.status,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
        : SizedBox();
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({
    Key? key,
    required this.image,
    this.category,
    required this.title,
    required this.stars,
    required this.reviews,
    required this.price,
    required this.oldPrice,
    required this.free,
    this.status,
  }) : super(key: key);

  final String? image;
  final Category? category;
  final String? title;
  final double? stars;
  final num? reviews;
  final String? price;
  final String? oldPrice;
  final bool? free;
  final StatusBean? status;

  String get categoryName =>
      category != null && category!.name.isNotEmpty ? '${unescape.convert(category!.name)} >' : '';

  @override
  Widget build(BuildContext context) {
    Widget buildPrice;

    if (free!) {
      buildPrice = Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Text(
          localizations.getLocalization('course_free_price'),
          textScaleFactor: 1.0,
          style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                color: ColorApp.dark,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
              ),
        ),
      );
    } else {
      buildPrice = Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: Row(
            children: <Widget>[
              Text(
                price!,
                textScaleFactor: 1.0,
                style: Theme.of(context)
                    .primaryTextTheme
                    .headlineSmall
                    ?.copyWith(color: ColorApp.dark, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
              ),
              Visibility(
                visible: oldPrice != null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    oldPrice.toString(),
                    textScaleFactor: 1.0,
                    style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                          color: Color(0xFF999999),
                          fontStyle: FontStyle.normal,
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: 300,
      child: Card(
        borderOnForeground: true,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0),
                  ),
                  child: Image.network(
                    image!,
                    width: 320,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                if (status != null)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: ColorApp.secondaryColor,
                      ),
                      child: Text(
                        status?.label ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CategoryDetailScreen.routeName,
                    arguments: CategoryDetailScreenArgs(category),
                  );
                },
                child: Text(
                  categoryName,
                  textScaleFactor: 1.0,
                  style: TextStyle(fontSize: 18, color: Color(0xFF2a3045).withOpacity(0.5)),
                ),
              ),
            ),
            Container(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 16.0, right: 16.0),
                child: Text(
                  unescape.convert(title ?? ''),
                  textScaleFactor: 1.0,
                  maxLines: 2,
                  style: TextStyle(fontSize: 22, color: ColorApp.dark),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Divider(
                color: Color(0xFFe0e0e0),
                thickness: 1.3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 15.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  RatingBar.builder(
                    initialRating: stars!,
                    minRating: 0,
                    direction: Axis.horizontal,
                    tapOnlyMode: true,
                    glow: false,
                    allowHalfRating: true,
                    ignoreGestures: true,
                    itemCount: 5,
                    itemSize: 19,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${stars} (${reviews})',
                      textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            buildPrice,
          ],
        ),
      ),
    );
  }
}
