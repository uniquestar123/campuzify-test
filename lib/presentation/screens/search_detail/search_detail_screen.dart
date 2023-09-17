import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/search_detail/search_detail_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/course_grid_item.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class SearchDetailScreenArgs {
  SearchDetailScreenArgs({
    this.searchText,
    this.categoryId,
    this.optionsBean,
  });

  final String? searchText;
  final int? categoryId;
  final OptionsBean? optionsBean;
}

class SearchDetailScreen extends StatelessWidget {
  const SearchDetailScreen() : super();

  static const String routeName = '/searchDetailScreen';

  @override
  Widget build(BuildContext context) {
    SearchDetailScreenArgs args = ModalRoute.of(context)?.settings.arguments as SearchDetailScreenArgs;
    return BlocProvider<SearchDetailBloc>(
      create: (context) => SearchDetailBloc(),
      child: SearchDetailWidget(
        searchText: args.searchText,
        categoryId: args.categoryId,
        optionsBean: args.optionsBean,
      ),
    );
  }
}

class SearchDetailWidget extends StatefulWidget {
  const SearchDetailWidget({
    this.searchText,
    this.categoryId,
    this.optionsBean,
  }) : super();

  final String? searchText;
  final int? categoryId;
  final OptionsBean? optionsBean;

  @override
  State<StatefulWidget> createState() => _SearchDetailWidgetState();
}

class _SearchDetailWidgetState extends State<SearchDetailWidget> {
  final TextEditingController _searchQuery = TextEditingController();

  @override
  void initState() {
    if (widget.searchText != null && widget.searchText!.isNotEmpty) {
      _searchQuery.text = widget.searchText!;
    }

    BlocProvider.of<SearchDetailBloc>(context).add(
      FetchEvent(_searchQuery.text, widget.categoryId),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F9),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: TextField(
          autofocus: true,
          cursorColor: ColorApp.mainColor,
          style: TextStyle(fontSize: 20),
          controller: _searchQuery,
          onChanged: (value) {
            if (value.trim().length > 1)
              BlocProvider.of<SearchDetailBloc>(context).add(
                FetchEvent(value, widget.categoryId),
              );
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: localizations.getLocalization('search_bar_title'),
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
      body: BlocBuilder<SearchDetailBloc, SearchDetailState>(
        builder: (context, state) {
          if (state is LoadingSearchDetailState) {
            return LoaderWidget(
              loaderColor: ColorApp.mainColor,
            );
          }

          if (state is LoadedSearchDetailState) {
            if (state.courses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      size: 150,
                      color: Colors.grey[400],
                    ),
                    Text(
                      localizations.getLocalization('nothing_found_search'),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Colors.grey[500], fontSize: 22),
                    ),
                    Text(
                      _searchQuery.text,
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Colors.grey[500], fontSize: 18),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: AlignedGridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  itemCount: state.courses.length,
                  itemBuilder: (context, index) {
                    var item = state.courses[index];

                    return CourseGridItem(
                      item,
                      optionsBean: widget.optionsBean,
                    );
                  },
                ),
              );
            }
          }

          return const SizedBox();
        },
      ),
    );
  }
}
