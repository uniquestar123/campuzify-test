import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/data/models/purchase/user_plans_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/course/course_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class PurchaseDialog extends StatefulWidget {
  const PurchaseDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PurchaseDialogState();
}

class PurchaseDialogState extends State<PurchaseDialog> {
  int selectedId = -1;

  @override
  void initState() {
    selectedId = BlocProvider.of<CourseBloc>(context).selectedPaymentId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is LoadedCourseState) {
          List<Widget> list = [];

          if (!state.courseDetailResponse.price!.free!) {
            list.add(
              _DefaultItem(
                selected: selectedId == -1,
                title: localizations.getLocalization('one_time_payment'),
                subtitle:
                    "${localizations.getLocalization("course_regular_price")} ${state.courseDetailResponse.price!.price}",
                value: state.courseDetailResponse.price!.price!,
                onTap: () {
                  setState(() {
                    selectedId = -1;
                  });
                },
              ),
            );
          }

          if (state.userPlans != null) {
            if (state.userPlans!.subscriptions.isNotEmpty && _haveValidPlan(state.userPlans!)) {
              state.userPlans!.subscriptions.forEach((value) {
                list.add(
                  _PriceItem(
                    selected: selectedId == int.parse(value!.subscriptionId),
                    title: localizations.getLocalization('enroll_with_membership'),
                    subtitle: value.name,
                    value: value.quotasLeft.toString(),
                    onTap: () {
                      setState(() {
                        selectedId = int.parse(value.subscriptionId);
                      });
                    },
                  ),
                );
              });
            } else if (BlocProvider.of<CourseBloc>(context).availablePlans.isNotEmpty) {
              BlocProvider.of<CourseBloc>(context).availablePlans.forEach((value) {
                list.add(
                  _PriceItem(
                    selected: selectedId == int.parse(value.id),
                    title: '${localizations.getLocalization("available_in_plan")} "${value.name}"',
                    subtitle: value.name,
                    value: value.quotasLeft.toString(),
                    onTap: () {
                      setState(() {
                        selectedId = int.parse(value.id);
                      });
                    },
                  ),
                );
              });
            }
          }

          // Button "Select"
          list.add(
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                minWidth: double.infinity,
                color: ColorApp.mainColor,
                onPressed: () async {
                  if (state.userPlans != null && state.userPlans!.subscriptions.isNotEmpty) {
                    BlocProvider.of<CourseBloc>(context).add(
                      PaymentSelectedEvent(selectedId, state.courseDetailResponse.id),
                    );
                    Navigator.pop(context);
                  } else {
                    if (selectedId != -1) {
                      if (state.userPlans!.otherSubscriptions) {
                        _warningDialog();
                      } else {
                        Navigator.of(context).pop(-1);
                      }
                    } else {
                      BlocProvider.of<CourseBloc>(context)
                          .add(PaymentSelectedEvent(selectedId, state.courseDetailResponse.id));
                      Navigator.pop(context, -1);
                    }
                  }
                },
                child: Text(
                  localizations.getLocalization('select_payment_button'),
                  textScaleFactor: 1.0,
                ),
                textColor: Colors.white,
              ),
            ),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: list,
            ),
          );
        }

        return LoaderWidget();
      },
    );
  }

  bool _haveValidPlan(UserPlansResponse plans) {
    bool have = false;
    plans.subscriptions.forEach((element) {
      if (element!.quotasLeft > 0) {
        have = true;
        return;
      }
    });
    return have;
  }

  /// Show this dialog when user have another subscription,
  /// and we offer pay new subscription
  _warningDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            localizations.getLocalization('warning'),
            textScaleFactor: 1.0,
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          content: Text(localizations.getLocalization('new_plan_over_the_old')),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.mainColor,
              ),
              child: Text(
                localizations.getLocalization('get_now'),
                textScaleFactor: 1.0,
              ),
              onPressed: () async => Navigator.of(context).pop(-1),
            ),
          ],
        );
      },
    );
  }
}

class _DefaultItem extends StatelessWidget {
  const _DefaultItem({
    Key? key,
    required this.onTap,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.value,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool selected;
  final String title;
  final String subtitle;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  selected ? Icons.check_circle : Icons.panorama_fish_eye,
                  color: selected ? ColorApp.secondaryColor : Colors.grey,
                  size: 40,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          subtitle,
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  value,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ColorApp.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceItem extends StatelessWidget {
  const _PriceItem({
    Key? key,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  final bool selected;
  final String title;
  final String subtitle;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    selected ? Icons.check_circle : Icons.panorama_fish_eye,
                    color: selected ? ColorApp.secondaryColor : Colors.grey,
                    size: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          title,
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: title.length > 20 ? 14 : 18),
                        ),
                        Text(
                          '$subtitle ',
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Visibility(
                visible: value != null,
                child: Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '$value',
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: ColorApp.secondaryColor),
                        ),
                        Text(
                          localizations.getLocalization('plan_count_left'),
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: 9, color: ColorApp.secondaryColor),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
