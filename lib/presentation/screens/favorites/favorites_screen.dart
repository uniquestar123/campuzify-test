import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/presentation/widgets/course_grid_item.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/presentation/widgets/unauthorized_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen(this.optionsBean);

  final OptionsBean? optionsBean;

  @override
  Widget build(BuildContext context) => _FavoritesScreenWidget(optionsBean: optionsBean);
}

class _FavoritesScreenWidget extends StatefulWidget {
  _FavoritesScreenWidget({this.optionsBean});

  final OptionsBean? optionsBean;

  @override
  State<StatefulWidget> createState() => _FavoritesScreenWidgetState();
}

class _FavoritesScreenWidgetState extends State<_FavoritesScreenWidget> {
  int? selectedId;

  @override
  void initState() {
    BlocProvider.of<FavoritesBloc>(context).add(FetchFavorites());
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
          localizations.getLocalization('favorites_title'),
          textScaleFactor: 1.0,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: BlocListener<FavoritesBloc,FavoritesState>(
        listener: (context, state) {
          if(state is SuccessDeleteFavoriteCourseState) {
            BlocProvider.of<FavoritesBloc>(context).add(FetchFavorites());
          }
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedId = null;
            });
          },
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is InitialFavoritesState) {
                return LoaderWidget(
                  loaderColor: ColorApp.mainColor,
                );
              }

              if (state is UnauthorizedState) {
                return UnauthorizedWidget(
                  onTap: () =>
                      Navigator.pushNamed(
                        context,
                        AuthScreen.routeName,
                        arguments: AuthScreenArgs(optionsBean: widget.optionsBean),
                      ),
                );
              }

              if (state is EmptyFavoritesState) {
                return EmptyWidget(
                  iconData: IconPath.emptyCourses,
                  title: localizations.getLocalization('no_user_favorites_screen_title'),
                );
              }

              if (state is LoadedFavoritesState) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
                  child: AlignedGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: state.favoriteCourses.length,
                    itemBuilder: (context, index) {
                      var item = state.favoriteCourses[index];
                      var itemId = item!.id;
                      var itemState = CourseGridItemEditingState.primary;

                      if (selectedId == null) {
                        itemState = CourseGridItemEditingState.primary;
                      } else {
                        if (selectedId == itemId) {
                          itemState = CourseGridItemEditingState.selected;
                        } else {
                          itemState = CourseGridItemEditingState.shadowed;
                        }
                      }
                      return CourseGridItemSelectable(
                        optionsBean: widget.optionsBean!,
                        coursesBean: item,
                        onTap: () {
                          if (selectedId != itemId) {
                            setState(() {
                              selectedId = null;
                            });
                          }
                        },
                        onDeletePressed: () {
                          setState(() {
                            selectedId = null;
                          });
                          BlocProvider.of<FavoritesBloc>(context).add(DeleteEvent(itemId));
                        },
                        onSelected: () {
                          setState(() {
                            setState(() {
                              selectedId = itemId;
                            });
                          });
                        },
                        itemState: itemState,
                      );
                    },
                  ),
                );
              }

              if (state is ErrorFavoritesState) {
                return ErrorCustomWidget(
                  onTap: () => BlocProvider.of<FavoritesBloc>(context).add(FetchFavorites()),
                );
              }

              return ErrorCustomWidget(
                onTap: () => BlocProvider.of<FavoritesBloc>(context).add(FetchFavorites()),
              );
            },
          ),
        ),
      ),
    );
  }
}

enum CourseGridItemEditingState { primary, selected, shadowed }

class CourseGridItemSelectable extends StatelessWidget {
  const CourseGridItemSelectable({
    required this.coursesBean,
    required this.onTap,
    required this.onDeletePressed,
    required this.onSelected,
    required this.itemState,
    required this.optionsBean,
  }) : super();

  final CoursesBean coursesBean;
  final OptionsBean optionsBean;
  final VoidCallback onDeletePressed;
  final VoidCallback onSelected;
  final VoidCallback onTap;
  final CourseGridItemEditingState itemState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onSelected,
      onTap: onTap,
      child: Stack(
        children: <Widget>[
          CourseGridItem(
            coursesBean,
            optionsBean: optionsBean,
          ),
          Visibility(
            visible: itemState == CourseGridItemEditingState.selected,
            child: Container(
              height: 205,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: ColorApp.mainColor, width: 2),
              ),
            ),
          ),
          Visibility(
            visible: itemState == CourseGridItemEditingState.selected,
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  backgroundColor: ColorApp.mainColor,
                  child: Icon(Icons.close),
                  onPressed: onDeletePressed,
                ),
              ),
            ),
          ),
          Visibility(
            visible: itemState == CourseGridItemEditingState.shadowed,
            child: Container(
              height: 200,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
