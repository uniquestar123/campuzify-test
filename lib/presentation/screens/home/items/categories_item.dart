import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/extensions/color_extensions.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/category/category.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/screens/category_detail/category_detail_screen.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class CategoriesWidget extends StatelessWidget {
  CategoriesWidget(
    this.title,
    this.categories,
    this.optionsBean, {
    Key? key,
  }) : super(key: key);

  final List<Category?> categories;
  final String? title;
  final OptionsBean? optionsBean;

  @override
  Widget build(BuildContext context) {
    return categories.length != 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 30.0),
                child: Text(
                  localizations.getLocalization('categories'),
                  textScaleFactor: 1.0,
                  style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                        color: ColorApp.dark,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 120, maxHeight: 160),
                  child: ListView.builder(
                    itemCount: categories.length,
                    padding: const EdgeInsets.all(8.0),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var item = categories[index];
                      var padding = (index == 0) ? 20.0 : 0.0;
                      var color = (item?.color != null) ? HexColor.fromHex(item!.color!) : ColorApp.dark;

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            CategoryDetailScreen.routeName,
                            arguments: CategoryDetailScreenArgs(item, optionsBean: optionsBean),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: padding),
                          child: CategoryItem(
                            imgUrl: item?.image,
                            color: color,
                            title: item!.name,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}

class CategoryItem extends StatelessWidget {
  CategoryItem({
    Key? key,
    this.imgUrl,
    required this.color,
    required this.title,
  }) : super(key: key);

  final String? imgUrl;
  final Color color;
  final String title;

  List<String>? get imgFormat => (imgUrl != '' || imgUrl != null) ? imgUrl?.split('.') : null;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Container(
        width: 140,
        height: 140,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (imgFormat != null)
                  ? SizedBox(
                      width: 50,
                      height: 50,
                      child: (imgFormat?.last == 'svg')
                          ? SvgPicture.asset(imgUrl!, color: Color(0xFFFFFFFF))
                          : Image.network(
                              imgUrl!,
                              width: double.infinity,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: Text(
                  unescape.convert(title),
                  maxLines: 4,
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
