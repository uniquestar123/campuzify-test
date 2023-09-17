import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:masterstudy_app/data/models/purchase/all_plans_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/plans/plans_bloc.dart';
import 'package:masterstudy_app/presentation/screens/web_checkout/web_checkout_screen.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class PlansScreen extends StatelessWidget {
  static const String routeName = '/plansScreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlansBloc(),
      child: PlansScreenWidget(),
    );
  }
}

class PlansScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlansScreenWidgetState();
}

class PlansScreenWidgetState extends State<PlansScreenWidget> {
  @override
  void initState() {
    BlocProvider.of<PlansBloc>(context).add(FetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansBloc, PlansState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFFF3F5F9),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              localizations.getLocalization('membership_plans'),
              textScaleFactor: 1.0,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  _buildBody(state) {
    if (state is LoadedPlansState) {
      return _buildList(state.plans);
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildList(List<AllPlansBean> plans) {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        var item = plans[index];
        return PlanWidget(
          item,
          onTap: () {
            _openCheckoutScreen(item);
          },
        );
      },
    );
  }

  _openCheckoutScreen(AllPlansBean allPlansBean) {
    var future = Navigator.pushNamed(
      context,
      WebCheckoutScreen.routeName,
      arguments: WebCheckoutScreenArgs(allPlansBean.button?.url),
    );
    future.then((value) {
      Navigator.pop(context);
    });
  }
}

class PlanWidget extends StatelessWidget {
  const PlanWidget(this.allPlansBean, {required this.onTap}) : super();
  final AllPlansBean allPlansBean;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 220,
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        allPlansBean.name,
                        textScaleFactor: 1.0,
                        style: TextStyle(fontSize: 20, color: Color(0xFF2A3045).withOpacity(0.8)),
                      ),
                      Text(
                        '\$' + allPlansBean.initialPayment.toString(),
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                      Visibility(
                        visible: allPlansBean.billingAmount != 0,
                        child: Text(
                          '\$' +
                              allPlansBean.billingAmount.toString() +
                              " ${localizations.getLocalization("plan_per_month")}",
                          textScaleFactor: 1.0,
                          style: TextStyle(color: Color(0xFF2A3045).withOpacity(0.8)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: 120,
                          child: MaterialButton(
                            minWidth: double.infinity,
                            color: ColorApp.secondaryColor,
                            onPressed: onTap,
                            child: Text(
                              allPlansBean.button?.text ?? localizations.getLocalization('get_now'),
                            ),
                            textColor: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: _buildWebView(allPlansBean.features!),
                  flex: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildWebView(String description) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Html(
          data: description,
        ),
      ],
    );
  }
}
