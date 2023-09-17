import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/presentation/screens/courses/courses_screen.dart';
import 'package:masterstudy_app/presentation/screens/favorites/favorites_screen.dart';
import 'package:masterstudy_app/presentation/screens/home/home_screen.dart';
import 'package:masterstudy_app/presentation/screens/home_simple/home_simple_screen.dart';
import 'package:masterstudy_app/presentation/screens/profile/profile_screen.dart';
import 'package:masterstudy_app/presentation/screens/search/search_screen.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class MainScreenArgs {
  MainScreenArgs(this.optionsBean, {this.selectedIndex});

  final OptionsBean optionsBean;

  final int? selectedIndex;
}

class MainScreen extends StatelessWidget {
  static const String routeName = '/mainScreen';

  @override
  Widget build(BuildContext context) {
    final MainScreenArgs args = ModalRoute.of(context)?.settings.arguments as MainScreenArgs;

    return MainScreenWidget(args.optionsBean, selectedIndex: args.selectedIndex);
  }
}

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget(
    this.optionsBean, {
    this.selectedIndex,
  }) : super();

  final OptionsBean optionsBean;
  final int? selectedIndex;

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreenWidget> {
  int _selectedIndex = 0;
  final _selectedItemColor = ColorApp.mainColor;
  final _unselectedItemColor = ColorApp.unselectedColor;

  @override
  void initState() {
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5.0,
        selectedFontSize: 10,
        backgroundColor: ColorApp.bgColor,
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) async {
          setState(() {
            _selectedIndex = index;
          });
          // Function for if user not access token, show auth screen when tap on bottom navigation(profile)
          if (index == 4) {
            if (await isAuth() == false) {
              Navigator.pushNamed(
                context,
                AuthScreen.routeName,
                arguments: AuthScreenArgs(
                  optionsBean: widget.optionsBean,
                  withoutToken: true,
                ),
              );
            }
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navHome, 0),
            label: localizations.getLocalization('home_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navCourses, 1),
            label: localizations.getLocalization('search_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navPlay, 2),
            label: localizations.getLocalization('courses_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navFavourites, 3),
            label: localizations.getLocalization('favorites_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navProfile, 4),
            label: localizations.getLocalization('profile_bottom_nav'),
          ),
        ],
      ),
    );
  }

  Color? _getItemColor(int index) => _selectedIndex == index ? _selectedItemColor : _unselectedItemColor;

  Widget _buildIcon(String iconData, int index) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SvgPicture.asset(
          iconData,
          height: 22.0,
          color: _getItemColor(index),
        ),
      );

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return widget.optionsBean.appView ? HomeSimpleScreen(widget.optionsBean) : HomeScreen(widget.optionsBean);
      case 1:
        return SearchScreen(optionsBean: widget.optionsBean);

      case 2:
        return CoursesScreen(
          () {
            setState(() {
              _selectedIndex = 0;
            });
          },
          optionsBean: widget.optionsBean,
        );
      case 3:
        return FavoritesScreen(widget.optionsBean);
      case 4:
        return ProfileScreen(
          () {
            setState(() {
              _selectedIndex = 2;
            });
          },
        );
      default:
        return Center(
          child: Text(
            'Not implemented!',
            textScaleFactor: 1.0,
          ),
        );
    }
  }
}
