import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/account/account.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/detail_profile/detail_profile_bloc.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/course_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/detail_profile/widgets/course_item.dart';
import 'package:masterstudy_app/presentation/screens/detail_profile/widgets/social_item.dart';
import 'package:masterstudy_app/presentation/screens/profile_edit/profile_edit_screen.dart';
import 'package:masterstudy_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:masterstudy_app/presentation/widgets/colored_tabbar_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:share_plus/share_plus.dart';

class DetailProfileScreenArgs {
  DetailProfileScreenArgs({this.optionsBean});

  DetailProfileScreenArgs.fromId({
    this.teacherId,
    this.optionsBean,
  });

  int? teacherId;
  OptionsBean? optionsBean;
}

class DetailProfileScreen extends StatelessWidget {
  const DetailProfileScreen() : super();

  static const String routeName = '/detailProfileScreen';

  @override
  Widget build(BuildContext context) {
    final DetailProfileScreenArgs args = ModalRoute.of(context)?.settings.arguments as DetailProfileScreenArgs;

    return BlocProvider(
      create: (context) => DetailProfileBloc()..add(FetchDetailProfile(args.teacherId)),
      child: DetailProfileWidget(
        optionsBean: args.optionsBean,
        teacherId: args.teacherId,
      ),
    );
  }
}

class DetailProfileWidget extends StatefulWidget {
  const DetailProfileWidget({Key? key, this.optionsBean, this.teacherId}) : super(key: key);

  final OptionsBean? optionsBean;
  final int? teacherId;

  @override
  State<StatefulWidget> createState() => _DetailProfileWidgetState();
}

class _DetailProfileWidgetState extends State<DetailProfileWidget> {
  late ScrollController _scrollController;
  String title = '';
  num kef = 2;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (!_isAppBarExpanded) {
          setState(() {
            title = '';
          });
        } else {
          if (BlocProvider.of<DetailProfileBloc>(context).account != null) {
            setState(() {
              title =
                  '${context.read<DetailProfileBloc>().account!.meta!.firstName} ${context.read<DetailProfileBloc>().account!.meta!.lastName}';
            });
          }
        }
      });
    super.initState();
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (MediaQuery.of(context).size.height / kef - kToolbarHeight);
  }

  int? get tabsCount => widget.teacherId != null ? 2 : null;

  @override
  Widget build(BuildContext context) {
    kef = (MediaQuery.of(context).size.height > 690) ? kef : 1.8;

    Widget buildContent = Scaffold(
      body: BlocBuilder<DetailProfileBloc, DetailProfileState>(
        builder: (context, state) {
          Account? account = context.watch<DetailProfileBloc>().account;
          bool isTeacher = false;
          String? userName = (account?.meta?.firstName != '' && account?.meta?.lastName != '')
              ? '${account?.meta?.firstName} ${account?.meta?.lastName}'
              : account?.login;
          List<CoursesBean?>? courses;

          if (state is LoadedDetailProfileState) {
            isTeacher = state.isTeacher;

            if (state.courses != null) {
              courses = state.courses;
            }
          }

          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: ColorApp.mainColor,
                  title: Text(
                    title,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  expandedHeight: MediaQuery.of(context).size.height / kef,
                  floating: false,
                  pinned: true,
                  snap: false,
                  actions: <Widget>[
                    if (isTeacher)
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          if (state is LoadedDetailProfileState) {
                            Share.share(account!.url!);
                          }
                        },
                      )
                    else
                      const SizedBox(),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => Navigator.of(context).pushNamed(
                        SearchDetailScreen.routeName,
                        arguments: SearchDetailScreenArgs(),
                      ),
                    ),
                  ],
                  bottom: isTeacher
                      ? ColoredTabBar(
                          Colors.white,
                          TabBar(
                            indicatorColor: ColorApp.mainColor,
                            tabs: _getTabs(state),
                          ),
                        )
                      : null,
                  flexibleSpace: Builder(
                    builder: (context) {
                      if (state is LoadedDetailProfileState) {
                        return FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          centerTitle: true,
                          background: SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60.0),
                                    child: CachedNetworkImage(
                                      imageUrl: account!.avatarUrl!,
                                      fit: BoxFit.fill,
                                      width: 100.0,
                                      placeholder: (context, url) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LoaderWidget(
                                          loaderColor: ColorApp.mainColor,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) {
                                        return SizedBox(
                                          width: 100.0,
                                          child: Image.asset(ImagePath.logo),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    userName ?? '',
                                    textScaleFactor: 1.0,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                                  ),
                                ),
                                if (isTeacher)
                                  Text(
                                    account.meta!.position,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                  )
                                else
                                  const SizedBox(),
                                if (isTeacher)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        RatingBar.builder(
                                          initialRating: account.rating!.average!.toDouble(),
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          ignoreGestures: true,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 16,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          glow: false,
                                          onRatingUpdate: (double value) {},
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            "${account.rating?.average!.toDouble()} ${account.rating?.totalMarks != '' ? '(${account.rating!.totalMarks})' : ''}",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  const SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      if (account.meta?.facebook != '')
                                        SocialItem(
                                          iconData: IconPath.facebook,
                                          url: account.meta?.facebook,
                                        )
                                      else
                                        const SizedBox(),
                                      if (account.meta!.twitter != '')
                                        SocialItem(
                                          iconData: IconPath.twitter,
                                          url: account.meta?.twitter,
                                        )
                                      else
                                        const SizedBox(),
                                      if (account.meta!.instagram != '')
                                        SocialItem(
                                          iconData: IconPath.instagram,
                                          url: account.meta?.instagram,
                                        )
                                      else
                                        const SizedBox(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ];
            },
            body: Builder(
              builder: (context) {
                if (state is InitialDetailProfileState) {
                  return LoaderWidget(
                    loaderColor: ColorApp.mainColor,
                  );
                }

                if (isTeacher) {
                  return TabBarView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          account!.meta!.description,
                          textScaleFactor: 1.0,
                        ),
                      ),
                      ListView.builder(
                        itemCount: courses!.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = courses![index];

                          double? rating = 0.0;
                          int? reviews = 0;
                          if (item?.rating?.total != null) {
                            rating = item!.rating!.average!.toDouble();
                          }
                          if (item!.rating!.total != null) {
                            reviews = item.rating?.total as int?;
                          }
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                CourseScreen.routeName,
                                arguments: CourseScreenArgs.fromCourseBean(item, optionsBean: widget.optionsBean),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                              child: DetailCourseItem(
                                image: item.images?.full,
                                category: item.categoriesObject.first,
                                title: item.title,
                                stars: rating,
                                reviews: reviews,
                                price: item.price?.price,
                                oldPrice: item.price?.oldPrice,
                                free: item.price?.free,
                                optionsBean: widget.optionsBean,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  if (account!.meta?.description != null && account.meta!.description.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        account.meta!.description,
                        textScaleFactor: 1.0,
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            localizations.getLocalization('empty_profile_text'),
                            textScaleFactor: 1.0,
                            style: TextStyle(color: Color(0xFFD7DAE2), fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: MaterialButton(
                              height: 40,
                              color: ColorApp.mainColor,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  ProfileEditScreen.routeName,
                                  arguments: ProfileEditScreenArgs(account),
                                );
                              },
                              child: Text(
                                localizations.getLocalization('empty_profile_button'),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          );
        },
      ),
    );

    if (tabsCount != null) {
      buildContent = DefaultTabController(
        length: tabsCount!,
        child: buildContent,
      );
    }

    return buildContent;
  }

  List<Widget> _getTabs(state) {
    List<Widget> tabs = [];

    if (state is LoadedDetailProfileState) {
      if (state.isTeacher) {
        tabs.addAll(
          [
            Tab(
              text: localizations.getLocalization('profile_bio_tab'),
            ),
            Tab(text: localizations.getLocalization('profile_courses_tab')),
          ],
        );
      }
    }

    return tabs;
  }
}
