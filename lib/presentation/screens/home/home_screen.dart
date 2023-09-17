import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/presentation/bloc/home/home_bloc.dart';
import 'package:masterstudy_app/presentation/screens/home/items/categories_item.dart';
import 'package:masterstudy_app/presentation/screens/home/items/new_courses_item.dart';
import 'package:masterstudy_app/presentation/screens/home/items/top_instructors.dart';
import 'package:masterstudy_app/presentation/screens/home/items/trending_item.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.optionsBean) : super();

  final OptionsBean? optionsBean;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeEvent()),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: ColorApp.mainColor,
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is InitialHomeState) {
              return LoaderWidget(
                loaderColor: ColorApp.mainColor,
              );
            }

            if (state is LoadedHomeState) {
              return ListView.builder(
                itemCount: state.layout.length,
                itemBuilder: (context, index) {
                  HomeLayoutBean? item = state.layout[index];

                  switch (item?.id) {
                    case 1:
                      return CategoriesWidget(item?.name, state.categoryList, optionsBean);
                    case 2:
                      return NewCoursesWidget(item?.name, state.coursesNew, optionsBean);
                    case 3:
                      return TrendingWidget(true, item?.name, state.coursesTrending, optionsBean);
                    case 4:
                      return TopInstructorsWidget(item?.name, state.instructors, optionsBean);
                    case 5:
                      return TrendingWidget(false, item?.name, state.coursesFree, optionsBean);
                    default:
                      return NewCoursesWidget(item?.name, state.coursesNew, optionsBean);
                  }
                },
              );
            }

            if (state is ErrorHomeState) {
              return ErrorCustomWidget(
                onTap: () => BlocProvider.of<HomeBloc>(context).add(LoadHomeEvent()),
              );
            }

            return ErrorCustomWidget(
              onTap: () => BlocProvider.of<HomeBloc>(context).add(LoadHomeEvent()),
            );
          },
        ),
      ),
    );
  }
}
