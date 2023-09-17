import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/search/search_screen_bloc.dart';
import 'package:masterstudy_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:masterstudy_app/presentation/widgets/course_grid_item.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, this.optionsBean});

  final OptionsBean? optionsBean;

  @override
  Widget build(BuildContext context) => SearchScreenWidget(optionsBean: optionsBean);
}

class SearchScreenWidget extends StatefulWidget {
  const SearchScreenWidget({super.key, this.optionsBean});

  final OptionsBean? optionsBean;

  @override
  State<StatefulWidget> createState() => SearchScreenWidgetState();
}

class SearchScreenWidgetState extends State<SearchScreenWidget> {
  @override
  void initState() {
    BlocProvider.of<SearchScreenBloc>(context).add(FetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F9),
      appBar: AppBar(
        backgroundColor: ColorApp.mainColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          localizations.getLocalization('search_title'),
          textScaleFactor: 1.0,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 16),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 2, right: 2),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                SearchDetailScreen.routeName,
                arguments: SearchDetailScreenArgs(optionsBean: widget.optionsBean),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Padding(
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
      body: BlocBuilder<SearchScreenBloc, SearchScreenState>(
        builder: (context, state) {
          if (state is InitialSearchScreenState) {
            return LoaderWidget(
              loaderColor: ColorApp.mainColor,
            );
          }

          if (state is LoadedSearchScreenState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Visibility(
                    visible: state.popularSearch.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 30.0),
                      child: Text(
                        localizations.getLocalization('popular_searchs'),
                        textScaleFactor: 1.0,
                        style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                              color: ColorApp.dark,
                              fontStyle: FontStyle.normal,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 22.0, top: 16),
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: state.popularSearch.map((value) => chip(unescape.convert(value!))).toList(),
                    ),
                  ),
                  state.newCourses.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: EmptyWidget(
                            iconData: IconPath.emptyCourses,
                            title: localizations.getLocalization('courses_is_empty'),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0, left: 30.0),
                              child: Text(
                                localizations.getLocalization('new_courses'),
                                textScaleFactor: 1.0,
                                style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                                      color: ColorApp.dark,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 22.0, right: 22.0),
                              child: AlignedGridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.newCourses.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item = state.newCourses[index];
                                  return CourseGridItem(
                                    item,
                                    optionsBean: widget.optionsBean,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            );
          }

          if (state is ErrorSearchScreenState) {
            return ErrorCustomWidget(
              onTap: () => BlocProvider.of<SearchScreenBloc>(context).add(FetchEvent()),
            );
          }

          return ErrorCustomWidget(
            onTap: () => BlocProvider.of<SearchScreenBloc>(context).add(FetchEvent()),
          );
        },
      ),
    );
  }

  Widget chip(String label) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        SearchDetailScreen.routeName,
        arguments: SearchDetailScreenArgs(
          searchText: label,
          optionsBean: widget.optionsBean,
        ),
      ),
      child: Chip(
        labelPadding: EdgeInsets.all(5.0),
        label: Text(
          label,
          textScaleFactor: 1.0,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(6.0),
      ),
    );
  }
}
