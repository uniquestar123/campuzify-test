import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/home_simple/home_simple_bloc.dart';
import 'package:masterstudy_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:masterstudy_app/presentation/widgets/course_grid_item.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class HomeSimpleScreen extends StatelessWidget {
  const HomeSimpleScreen(this.optionsBean) : super();

  final OptionsBean optionsBean;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.bgColorGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorApp.mainColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(26),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                SearchDetailScreen.routeName,
                arguments: SearchDetailScreenArgs(),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                localizations.getLocalization('search_bar_title'),
                                textScaleFactor: 1.0,
                                style: TextStyle(color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                            Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<HomeSimpleBloc, HomeSimpleState>(
        builder: (context, state) {
          if (state is InitialHomeSimpleState) {
            return LoaderWidget(
              loaderColor: ColorApp.mainColor,
            );
          }

          if (state is LoadedHomeSimpleState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, left: 30.0, right: 30.0, bottom: 10.0),
                    child: Text(
                      localizations.getLocalization('new_courses_title'),
                      textScaleFactor: 1.0,
                      style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                            color: ColorApp.dark,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: AlignedGridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.coursesNew.length,
                      itemBuilder: (context, index) {
                        final item = state.coursesNew[index];

                        return CourseGridItem(
                          item,
                          optionsBean: optionsBean,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is EmptyHomeSimpleState) {
            return EmptyWidget(
              iconData: IconPath.emptyCourses,
              title: localizations.getLocalization('courses_is_empty'),
            );
          }

          if (state is ErrorHomeSimpleState) {
            return ErrorCustomWidget(
              onTap: () => BlocProvider.of<HomeSimpleBloc>(context).add(LoadHomeSimpleEvent()),
            );
          }

          return ErrorCustomWidget(
            onTap: () => BlocProvider.of<HomeSimpleBloc>(context).add(LoadHomeSimpleEvent()),
          );
        },
      ),
    );
  }
}
