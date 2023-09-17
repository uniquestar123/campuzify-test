import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/category/category.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/category_detail/category_detail_bloc.dart';
import 'package:masterstudy_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:masterstudy_app/presentation/widgets/course_grid_item.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_styles.dart';

class CategoryDetailScreenArgs {
  CategoryDetailScreenArgs(this.category, {this.optionsBean});

  final Category? category;
  final OptionsBean? optionsBean;
}

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen() : super();

  static const String routeName = '/categoryDetailScreen';

  @override
  Widget build(BuildContext context) {
    final CategoryDetailScreenArgs args = ModalRoute.of(context)?.settings.arguments as CategoryDetailScreenArgs;
    return BlocProvider(
      create: (context) => CategoryDetailBloc(),
      child: _CategoryDetailScreenWidget(
        args.category!,
        args.optionsBean,
      ),
    );
  }
}

class _CategoryDetailScreenWidget extends StatefulWidget {
  const _CategoryDetailScreenWidget(this.category, this.optionsBean);

  final Category category;
  final OptionsBean? optionsBean;

  @override
  State<StatefulWidget> createState() => _CategoryDetailScreenWidgetState();
}

class _CategoryDetailScreenWidgetState extends State<_CategoryDetailScreenWidget> {
  late Category selectedCategory;

  @override
  void initState() {
    BlocProvider.of<CategoryDetailBloc>(context).add(FetchEvent(widget.category.id));
    selectedCategory = widget.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryDetailBloc, CategoryDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFFF3F5F9),
          appBar: AppBar(
            title: state is LoadedCategoryDetailState
                ? _buildTitleDropDown(state)
                : Text(
                    selectedCategory.name,
                    style: kAppBarPopUpTextStyle,
                  ),
            backgroundColor: ColorApp.mainColor,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight + 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, left: 2, right: 2),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                        SearchDetailScreen.routeName,
                        arguments: SearchDetailScreenArgs(
                          categoryId: selectedCategory.id,
                        ),
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
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Builder(
              builder: (context) {
                Widget? buildContent;

                if (state is InitialCategoryDetailState) {
                  buildContent = Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: LoaderWidget(
                      loaderColor: ColorApp.mainColor,
                    ),
                  );
                }

                if (state is ErrorCategoryDetailState) {
                  buildContent = Center(
                    child: ErrorCustomWidget(
                      onTap: () => BlocProvider.of<CategoryDetailBloc>(context).add(FetchEvent(state.categoryId)),
                    ),
                  );
                }

                if (state is LoadedCategoryDetailState) {
                  buildContent = Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 30.0, bottom: 5.0),
                        child: Text(
                          unescape.convert(selectedCategory.name),
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
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemCount: state.courses.length,
                          itemBuilder: (context, index) {
                            final item = state.courses[index];

                            return CourseGridItem(
                              item,
                              optionsBean: widget.optionsBean,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return buildContent ??
                    ErrorCustomWidget(
                      onTap: () => BlocProvider.of<CategoryDetailBloc>(context).add(FetchEvent(selectedCategory.id)),
                    );
              },
            ),
          ),
        );
      },
    );
  }

  _buildTitleDropDown(LoadedCategoryDetailState state) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return state.categoryList.map((Category catList) {
          return PopupMenuItem<Category>(
            value: catList,
            child: Text(
              unescape.convert(catList.name),
              textScaleFactor: 1.0,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList();
      },
      onSelected: (Category? selectedCat) {
        setState(() {
          selectedCategory = selectedCat!;
        });
        context.read<CategoryDetailBloc>().add(FetchEvent(selectedCat!.id));
      },
      child: Row(
        children: [
          Text(
            selectedCategory.name,
            style: kAppBarPopUpTextStyle,
          ),
          const SizedBox(width: 8.0),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
