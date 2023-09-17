import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/screens/category_detail/category_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/course_detail_screen.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class CourseGridItem extends StatelessWidget {
  CourseGridItem(
    this.coursesBean, {
    this.optionsBean,
  });

  final CoursesBean? coursesBean;
  final OptionsBean? optionsBean;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      onTap: () => Navigator.pushNamed(
        context,
        CourseScreen.routeName,
        arguments: CourseScreenArgs.fromCourseBean(
          coursesBean!,
          optionsBean: optionsBean,
        ),
      ),
      child: CourseGridCard(
        optionsBean: optionsBean,
        coursesBean: coursesBean,
      ),
    );
  }
}

class CourseGridCard extends StatelessWidget {
  const CourseGridCard({Key? key, required this.coursesBean, required this.optionsBean}) : super(key: key);

  final CoursesBean? coursesBean;
  final OptionsBean? optionsBean;

  double? get rating => coursesBean?.rating?.average?.toDouble();

  num? get reviews => coursesBean?.rating?.total;

  String? get categoryName => (coursesBean?.categoriesObject != null && coursesBean!.categoriesObject.isNotEmpty)
      ? coursesBean?.categoriesObject.first?.name ?? ''
      : '';

  @override
  Widget build(BuildContext context) {
    Widget buildPrice = Text(
      coursesBean!.price!.free ? localizations.getLocalization('course_free_price') : coursesBean!.price!.price!,
      textScaleFactor: 1.0,
      style: Theme.of(context)
          .primaryTextTheme
          .titleMedium!
          .copyWith(color: ColorApp.dark, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
    );

    if (coursesBean?.price?.oldPrice != null) {
      buildPrice = Row(
        children: [
          buildPrice,
          const SizedBox(width: 4.0),
          Text(
            (coursesBean?.price?.oldPrice != null) ? coursesBean!.price!.oldPrice! : ' ',
            textScaleFactor: 1.0,
            style: Theme.of(context).primaryTextTheme.titleMedium!.copyWith(
                  color: Color(0xFF999999),
                  fontStyle: FontStyle.normal,
                  decoration: (coursesBean?.price?.oldPrice != null) ? TextDecoration.lineThrough : TextDecoration.none,
                ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  child: Hero(
                    tag: coursesBean!.id,
                    child: Image.network(
                      coursesBean?.images?.small ?? '',
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width > 450 ? 220.0 : 95.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (coursesBean?.status != null)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: ColorApp.secondaryColor,
                      ),
                      child: Text(
                        coursesBean?.status?.label ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  CategoryDetailScreen.routeName,
                  arguments: CategoryDetailScreenArgs(
                    coursesBean?.categoriesObject.first,
                    optionsBean: optionsBean,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
                child: Text(
                  unescape.convert(categoryName!),
                  textScaleFactor: 1.0,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12.0,
                      ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 4.0, right: 4.0, bottom: 4.0),
              child: Text(
                unescape.convert(coursesBean?.title ?? '') + '\n',
                maxLines: 2,
                textScaleFactor: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Row(
                children: <Widget>[
                  RatingBar.builder(
                    initialRating: rating!,
                    minRating: 0,
                    direction: Axis.horizontal,
                    tapOnlyMode: true,
                    glow: false,
                    allowHalfRating: true,
                    ignoreGestures: true,
                    itemCount: 5,
                    itemSize: 14,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  Text(
                    '$rating ($reviews)',
                    textScaleFactor: 1.0,
                    style: Theme.of(context).primaryTextTheme.bodySmall?.copyWith(color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
              child: buildPrice,
            ),
          ],
        ),
      ),
    );
  }
}
