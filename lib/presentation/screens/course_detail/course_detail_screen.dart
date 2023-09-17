import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/category/category.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/data/models/orders/orders_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/course/course_bloc.dart';
import 'package:masterstudy_app/presentation/screens/category_detail/category_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/tabs/curriculum_widget.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/tabs/faq_widget.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/tabs/overview_widget.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/widgets/bottom_widget.dart';
import 'package:masterstudy_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/web_checkout/web_checkout_screen.dart';
import 'package:masterstudy_app/presentation/widgets/colored_tabbar_widget.dart';
import 'package:masterstudy_app/presentation/widgets/dialog_author.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

class CourseScreenArgs {
  CourseScreenArgs(
    this.id,
    this.title,
    this.images,
    this.categories,
    this.price,
    this.rating,
    this.featured,
    this.status,
    this.categoriesObject,
    this.optionsBean,
  );

  CourseScreenArgs.fromCourseBean(CoursesBean coursesBean, {OptionsBean? optionsBean})
      : id = coursesBean.id,
        title = coursesBean.title,
        images = coursesBean.images,
        categories = coursesBean.categories,
        price = coursesBean.price,
        rating = coursesBean.rating,
        featured = coursesBean.featured,
        status = coursesBean.status,
        categoriesObject = coursesBean.categoriesObject,
        optionsBean = optionsBean;

  CourseScreenArgs.fromOrderListBean(CartItemsBean cart_itemsBean)
      : id = cart_itemsBean.cartItemId,
        title = cart_itemsBean.title,
        images = ImagesBean(full: cart_itemsBean.imageUrl, small: cart_itemsBean.imageUrl),
        categories = [],
        price = null,
        rating = null,
        featured = null,
        status = null,
        categoriesObject = [];
  int? id;
  String? title;
  ImagesBean? images;
  List<String?> categories;
  PriceBean? price;
  RatingBean? rating;
  String? featured;
  StatusBean? status;
  List<Category?> categoriesObject;
  OptionsBean? optionsBean;
}

class CourseScreen extends StatelessWidget {
  static const String routeName = '/courseScreen';

  @override
  Widget build(BuildContext context) {
    final CourseScreenArgs args = ModalRoute.of(context)?.settings.arguments as CourseScreenArgs;
    return _CourseScreenWidget(
      args,
      args.optionsBean,
    );
  }
}

class _CourseScreenWidget extends StatefulWidget {
  const _CourseScreenWidget(this.coursesBean, this.optionsBean);

  final CourseScreenArgs coursesBean;
  final OptionsBean? optionsBean;

  @override
  State<StatefulWidget> createState() => _CourseScreenWidgetState();
}

class _CourseScreenWidgetState extends State<_CourseScreenWidget> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController animation;
  late AnimationController animationBottom;
  late Animation<double> _fadeInFadeOut;
  late bool _isFav;
  Color _favIcoColor = Colors.white;
  var screenHeight;
  String title = '';
  num kef = 2;
  String? selectedPlan = '';

  bool get _isAppBarExpanded {
    if (screenHeight == null) screenHeight = MediaQuery.of(context).size.height;
    if (_scrollController.offset > (screenHeight / kef - (kToolbarHeight * kef)))
      return _scrollController.hasClients && _scrollController.offset > (screenHeight / kef - (kToolbarHeight * kef));
    return false;
  }

  @override
  void initState() {
    BlocProvider.of<CourseBloc>(context).add(FetchEvent(widget.coursesBean.id!));

    animationBottom = BottomSheet.createAnimationController(this);
    animationBottom.duration = Duration(seconds: 1);
    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(0.25, 1, curve: Curves.easeIn),
      ),
    );
    animation.forward();

    _scrollController = ScrollController()
      ..addListener(() {
        if (!_isAppBarExpanded) {
          setState(() {
            title = '';
          });
        } else {
          setState(() {
            title = widget.coursesBean.title!;
          });
        }
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    animation.forward();

    kef = (MediaQuery.of(context).size.height > 690) ? kef : 1.8;

    return BlocListener<CourseBloc, CourseState>(
      listener: (context, state) {
        // Favorite Course or not
        if (state is LoadedCourseState) {
          setState(() {
            _isFav = state.courseDetailResponse.isFavorite!;
            _favIcoColor = (state.courseDetailResponse.isFavorite!) ? Colors.red : Colors.white;
          });
        }

        // Purchase
        if (state is OpenPurchaseState) {
          var future = Navigator.pushNamed(
            context,
            WebCheckoutScreen.routeName,
            arguments: WebCheckoutScreenArgs(state.url),
          );
          future.then((value) {
            BlocProvider.of<CourseBloc>(context).add(FetchEvent(widget.coursesBean.id!));
          });
        }
      },
      child: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          return DefaultTabController(
            length: context.read<CourseBloc>().countTab,
            child: Scaffold(
              body: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  String? categories = '';
                  double? ratingAverage = 0.0;
                  double? ratingTotal = 0.0;

                  if (state is LoadedCourseState) {
                    if (state.courseDetailResponse.categoriesObject.isNotEmpty) {
                      categories = state.courseDetailResponse.categoriesObject.first?.name;
                    }
                    ratingAverage = state.courseDetailResponse.rating?.average!.toDouble();
                    ratingTotal = double.parse(state.courseDetailResponse.rating!.total.toString());
                  } else {
                    if (widget.coursesBean.categoriesObject.isNotEmpty) {
                      categories = widget.coursesBean.categoriesObject.first?.name;
                    }

                    if (widget.coursesBean.rating != null) {
                      ratingAverage = double.parse(widget.coursesBean.rating!.average.toString());
                      ratingTotal = double.parse(widget.coursesBean.rating!.total.toString());
                    }
                  }

                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: ColorApp.mainColor,
                      title: Text(
                        title,
                        textScaleFactor: 1.0,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      expandedHeight: MediaQuery.of(context).size.height / kef,
                      floating: false,
                      pinned: true,
                      snap: false,
                      actions: <Widget>[
                        // Share Icon
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            state is LoadedCourseState
                                ? Share.share(state.courseDetailResponse.url!)
                                : logger.i('No url for share course');
                          },
                        ),
                        // Fav Icon
                        Visibility(
                          visible: preferences.getString(PreferencesName.apiToken) == null ||
                                  preferences.getString(PreferencesName.apiToken) == ''
                              ? false
                              : true,
                          child: IconButton(
                            icon: Icon(Icons.favorite),
                            color: _favIcoColor,
                            onPressed: () {
                              setState(() {
                                _favIcoColor = _isFav ? Colors.white : Colors.red;
                                _isFav = (_isFav) ? false : true;
                              });

                              if (state is LoadedCourseState) {
                                if (state.courseDetailResponse.isFavorite!) {
                                  BlocProvider.of<CourseBloc>(context).add(DeleteFromFavorite(widget.coursesBean.id!));
                                } else {
                                  BlocProvider.of<CourseBloc>(context).add(AddToFavorite(widget.coursesBean.id!));
                                }
                              }
                            },
                          ),
                        ),
                        //Icon search
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () => Navigator.of(context).pushNamed(
                            SearchDetailScreen.routeName,
                            arguments: SearchDetailScreenArgs(),
                          ),
                        ),
                      ],
                      bottom: ColoredTabBar(
                        Colors.white,
                        TabBar(
                          indicatorColor: ColorApp.mainColor,
                          tabs: [
                            Tab(
                              text: localizations.getLocalization('course_overview_tab'),
                            ),
                            Tab(
                              text: localizations.getLocalization('course_curriculum_tab'),
                            ),
                            if (state is LoadedCourseState)
                              if (state.courseDetailResponse.faq != null && state.courseDetailResponse.faq!.isNotEmpty)
                                Tab(
                                  text: localizations.getLocalization('course_faq_tab'),
                                ),
                          ],
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Stack(
                          children: <Widget>[
                            Hero(
                              tag: widget.coursesBean.images?.small as Object,
                              child: FadeInImage.memoryNetwork(
                                image: widget.coursesBean.images!.small!,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / kef,
                                placeholder: kTransparentImage,
                              ),
                            ),
                            FadeTransition(
                              opacity: _fadeInFadeOut,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorApp.mainColor.withOpacity(0.5),
                                ),
                              ),
                            ),
                            FadeTransition(
                              opacity: _fadeInFadeOut,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              CategoryDetailScreen.routeName,
                                              arguments: CategoryDetailScreenArgs(
                                                widget.coursesBean.categoriesObject[0],
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    unescape.convert(categories!),
                                                    textScaleFactor: 1.0,
                                                    style:
                                                        TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.white.withOpacity(0.5),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (state is LoadedCourseState)
                                          GestureDetector(
                                            onTap: () => showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) => DialogAuthorWidget(state),
                                            ),
                                            child: CircleAvatar(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                child: CachedNetworkImage(
                                                  imageUrl: state.courseDetailResponse.author!.avatarUrl!,
                                                  placeholder: (BuildContext context, String url) {
                                                    return const SizedBox();
                                                  },
                                                  errorWidget: (BuildContext context, String url, dynamic widget) {
                                                    return Icon(
                                                      Icons.error_outline_rounded,
                                                      color: ColorApp.redColor,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        unescape.convert(widget.coursesBean.title!),
                                        textScaleFactor: 1.0,
                                        style: TextStyle(color: Colors.white, fontSize: 32),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0, right: 16.0),
                                      child: Row(
                                        children: <Widget>[
                                          RatingBar.builder(
                                            initialRating: ratingAverage!,
                                            minRating: 0,
                                            allowHalfRating: true,
                                            direction: Axis.horizontal,
                                            tapOnlyMode: true,
                                            glow: false,
                                            ignoreGestures: true,
                                            itemCount: 5,
                                            itemSize: 19,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              '${ratingAverage.toDouble()} (${ratingTotal} ${localizations.getLocalization('reviews_count')})',
                                              textScaleFactor: 1.0,
                                              style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.5)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 150),
                  child: Builder(
                    builder: (BuildContext context) {
                      if (state is InitialCourseState) {
                        return LoaderWidget(
                          loaderColor: ColorApp.mainColor,
                        );
                      }

                      if (state is LoadedCourseState) {
                        return TabBarView(
                          children: <Widget>[
                            OverviewWidget(
                              state.courseDetailResponse,
                              state.reviewResponse,
                              () {
                                _scrollController.jumpTo(screenHeight / kef - (kToolbarHeight * kef));
                              },
                              widget.optionsBean!,
                            ),
                            CurriculumWidget(state.courseDetailResponse, widget.optionsBean),
                            if (state.courseDetailResponse.faq != null && state.courseDetailResponse.faq!.isNotEmpty)
                              FaqWidget(state.courseDetailResponse),
                          ],
                        );
                      }
                      if (state is ErrorCourseState) {
                        return ErrorCustomWidget(
                          onTap: () => BlocProvider.of<CourseBloc>(context).add(FetchEvent(widget.coursesBean.id!)),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
              bottomNavigationBar: BlocProvider.value(
                value: BlocProvider.of<CourseBloc>(context),
                child: BottomWidget(
                  coursesBean: widget.coursesBean,
                  optionsBean: widget.optionsBean,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
