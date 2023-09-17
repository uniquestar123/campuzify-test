import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/instructors/instructors_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/screens/detail_profile/detail_profile_screen.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class TopInstructorsWidget extends StatelessWidget {
  TopInstructorsWidget(this.title, this.list, this.optionsBean, {Key? key}) : super(key: key);

  final List<InstructorBean?> list;
  final String? title;
  final OptionsBean? optionsBean;

  @override
  Widget build(BuildContext context) {
    return (list.isNotEmpty)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 30.0, bottom: 20),
                child: Text(
                  localizations.getLocalization('instructors'),
                  textScaleFactor: 1.0,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .titleLarge
                      ?.copyWith(color: ColorApp.dark, fontStyle: FontStyle.normal),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFeef1f7)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 250, maxHeight: 250),
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        var item = list[index];
                        return Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: _buildCard(
                            context,
                            item?.id,
                            item?.avatarUrl,
                            item?.meta?.firstName,
                            item?.meta?.lastName,
                            item?.meta?.position,
                            item?.rating?.average,
                            item?.rating?.marksNum,
                            item?.login,
                          ),
                        );
                      },
                      padding: const EdgeInsets.all(8.0),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  _buildCard(context, id, avatar, firstName, lastName, position, stars, reviewsCount, login) {
    return SizedBox(
      width: 160,
      child: InkWell(
        onTap: () async {
          if (!await isAuth()) {
            showFlutterToast(title: localizations.getLocalization('not_authenticated'));
          } else {
            Navigator.pushNamed(
              context,
              DetailProfileScreen.routeName,
              arguments: DetailProfileScreenArgs.fromId(
                teacherId: id,
                optionsBean: optionsBean,
              ),
            );
          }
        },
        child: Card(
          borderOnForeground: true,
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60.0),
                  child: Image.network(
                    avatar,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: firstName != '' && lastName != ''
                    ? Text(
                        '$firstName' + ' $lastName',
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headlineSmall
                            ?.copyWith(color: ColorApp.dark, fontSize: 18),
                      )
                    : Text(
                        login,
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headlineSmall
                            ?.copyWith(color: ColorApp.dark, fontSize: 18),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8, right: 8),
                child: Text(
                  position,
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(color: Colors.grey[600], fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: RatingBar.builder(
                  initialRating: stars.toDouble(),
                  minRating: 0,
                  direction: Axis.horizontal,
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '$stars ($reviewsCount ${localizations.getLocalization('reviews_count')})',
                  textScaleFactor: 1.0,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
