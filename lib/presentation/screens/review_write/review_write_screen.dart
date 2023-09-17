import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/review_write/review_write_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/presentation/widgets/alert_dialogs.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';
import 'package:shimmer/shimmer.dart';

class ReviewWriteScreenArgs {
  ReviewWriteScreenArgs(
    this.courseId,
    this.courseTitle, {
    this.optionsBean,
  });

  final int courseId;
  final String courseTitle;
  OptionsBean? optionsBean;
}

class ReviewWriteScreen extends StatelessWidget {
  const ReviewWriteScreen() : super();

  static const String routeName = '/reviewWriteScreen';

  @override
  Widget build(BuildContext context) {
    final ReviewWriteScreenArgs args = ModalRoute.of(context)?.settings.arguments as ReviewWriteScreenArgs;
    return BlocProvider(
      create: (context) => ReviewWriteBloc()..add(FetchEvent(args.courseId)),
      child: _ReviewWriteScreenWidget(
        args.courseId,
        args.courseTitle,
        args.optionsBean,
      ),
    );
  }
}

class _ReviewWriteScreenWidget extends StatefulWidget {
  const _ReviewWriteScreenWidget(this.courseId, this.courseTitle, this.optionsBean);

  final int courseId;
  final String courseTitle;
  final OptionsBean? optionsBean;

  @override
  State<StatefulWidget> createState() => _ReviewWriteScreenWidgetState();
}

class _ReviewWriteScreenWidgetState extends State<_ReviewWriteScreenWidget> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _reviewController = TextEditingController();

  double _rating = 0.0;

  /// Variable for check is rating null or not
  bool _ratingIsEmpty = false;

  FocusNode myFocusNode = FocusNode();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFF3F5F9),
        appBar: AppBar(
          backgroundColor: Color(0xFF273044),
          title: Text(
            localizations.getLocalization('write_a_review_title'),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
        body: BlocListener<ReviewWriteBloc, ReviewWriteState>(
          listener: (context, state) {
            if (state is SuccessAddReviewState) {
              _reviewController.clear();
              _rating = 0;
              _ratingIsEmpty = false;

              showFlutterToast(
                title: localizations.getLocalization('review_success'),
              );
            }
          },
          child: BlocBuilder<ReviewWriteBloc, ReviewWriteState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        buildWidgetAvatar(state),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Text(
                            widget.courseTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: TextFormField(
                            cursorColor: ColorApp.mainColor,
                            textInputAction: TextInputAction.done,
                            controller: _reviewController,
                            maxLines: 8,
                            textAlignVertical: TextAlignVertical.top,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return localizations.getLocalization('bio_helper');
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorApp.mainColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorApp.mainColor),
                              ),
                              labelStyle: TextStyle(color: myFocusNode.hasFocus ? ColorApp.mainColor : Colors.black),
                              labelText: localizations.getLocalization('enter_review'),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: RatingBar.builder(
                            glow: false,
                            initialRating: _rating,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            unratedColor: Color(0xFFD7DAE2),
                            onRatingUpdate: (rating) {
                              _rating = rating;
                            },
                          ),
                        ),
                        if (_ratingIsEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              localizations.getLocalization('choose_rating'),
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        else
                          const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                          child: SizedBox(
                            height: kButtonHeight,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorApp.secondaryColor,
                              ),
                              onPressed: state is LoadingAddReviewState
                                  ? null
                                  : () async {
                                      if (!await isAuth()) {
                                        showNotAuthorizedDialog(
                                          context,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              AuthScreen.routeName,
                                              arguments: AuthScreenArgs(
                                                optionsBean: widget.optionsBean,
                                              ),
                                            );
                                          },
                                        );
                                      }

                                      if (_rating == 0) {
                                        setState(() {
                                          _ratingIsEmpty = true;
                                        });
                                      }

                                      if (_formKey.currentState!.validate() && _rating != 0) {
                                        BlocProvider.of<ReviewWriteBloc>(context).add(
                                          SaveReviewEvent(
                                            widget.courseId,
                                            _rating.toInt(),
                                            _reviewController.text,
                                          ),
                                        );
                                      }
                                    },
                              child: state is LoadingAddReviewState
                                  ? LoaderWidget()
                                  : Text(
                                      localizations.getLocalization('submit_button'),
                                      textScaleFactor: 1.0,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  buildWidgetAvatar(ReviewWriteState state) {
    if (state is LoadedReviewWriteState) {
      return avatarWidget(state.account.avatarUrl);
    }

    if (state is SuccessAddReviewState) {
      return avatarWidget(state.account.avatarUrl);
    }

    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[200]!,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.amber),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  avatarWidget(String? url) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(60.0)),
        child: CachedNetworkImage(
          width: 50.0,
          height: 50.0,
          imageUrl: url ?? '',
          placeholder: (BuildContext context, String url) => Padding(
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
    );
  }
}
