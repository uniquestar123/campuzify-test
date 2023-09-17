import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/orders/orders_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/orders/orders_bloc.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/course_detail_screen.dart';
import 'package:masterstudy_app/presentation/widgets/colored_tabbar_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:transparent_image/transparent_image.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen() : super();
  static const String routeName = '/ordersScreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersBloc(),
      child: OrdersWidget(),
    );
  }
}

class OrdersWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OrdersWidgetState();
}

class OrdersWidgetState extends State<OrdersWidget> {
  @override
  void initState() {
    BlocProvider.of<OrdersBloc>(context).add(FetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Color(0xFFF3F5F9),
            appBar: AppBar(
              backgroundColor: ColorApp.mainColor,
              centerTitle: true,
              title: Text(
                localizations.getLocalization('user_orders_title'),
                textScaleFactor: 1.0,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              bottom: ColoredTabBar(
                Colors.white,
                TabBar(
                  indicatorColor: ColorApp.mainColor,
                  tabs: [
                    Tab(
                      text: localizations.getLocalization('one_time_payment'),
                    ),
                    Tab(
                      text: localizations.getLocalization('membership'),
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 150),
                child: _buildBody(state),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildBody(state) {
    if (state is LoadedOrdersState) {
      return TabBarView(
        children: <Widget>[
          //OneTimePayment
          ListView.builder(
            itemCount: state.orders.posts.length,
            itemBuilder: (BuildContext ctx, int index) {
              return OrderWidget(state.orders.posts[index], index == 0);
            },
          ),
          //Memberships
          ListView.builder(
            itemCount: state.orders.memberships.length,
            itemBuilder: (BuildContext ctx, int index) {
              return MembershipWidget(state.orders.memberships[index], index == 0);
            },
          )
        ],
      );
    }

    if (state is EmptyOrdersState) return _buildEmptyList();

    if (state is EmptyMembershipsState) return _buildEmptyList();

    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildEmptyList() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 150,
            height: 150,
            child: SvgPicture.asset(
              IconPath.emptyCourses,
            ),
          ),
          Text(
            localizations.getLocalization('no_user_orders_screen_title'),
            textScaleFactor: 1.0,
            style: TextStyle(color: Color(0xFFD7DAE2), fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class OrderWidget extends StatefulWidget {
  OrderWidget(this.orderBean, this.opened) : super();
  final OrderBean? orderBean;
  final bool opened;

  @override
  State<StatefulWidget> createState() => OrderWidgetState();
}

class OrderWidgetState extends State<OrderWidget> {
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    expanded = widget.opened;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[_buildTitle(), _buildContent()],
          ),
        ),
      ),
    );
  }

  _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              '${widget.orderBean!.dateFormatted}  id:${widget.orderBean!.id}',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 20),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                expanded = !expanded;
              });
            },
            icon: Icon(
              expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: ColorApp.mainColor,
            ),
          )
        ],
      ),
    );
  }

  _buildContent() {
    return Visibility(
      visible: expanded,
      child: Column(
        children: <Widget>[
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 3,
              thickness: 0.5,
              color: Color(0xFF707070),
            ),
            itemCount: widget.orderBean!.cartItems.length,
            itemBuilder: (context, index) {
              var item = widget.orderBean!.cartItems[index];
              return _buildCartItem(item!);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Center(
              child: Text(
                widget.orderBean!.orderKey,
                textScaleFactor: 1.0,
                style: TextStyle(color: Color(0xFF999999), fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildCartItem(CartItemsBean item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          CourseScreen.routeName,
          arguments: CourseScreenArgs.fromOrderListBean(item),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FadeInImage.memoryNetwork(
                  fit: BoxFit.cover,
                  width: 200,
                  height: 100,
                  placeholder: kTransparentImage,
                  image: item.imageUrl,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      textScaleFactor: 1.0,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        item.priceFormatted,
                        textScaleFactor: 1.0,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Status: ${widget.orderBean!.status}',
                        textScaleFactor: 1.0,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MembershipWidget extends StatefulWidget {
  MembershipWidget(this.membershipsBean, this.opened) : super();
  final MembershipBean? membershipsBean;
  final bool opened;

  @override
  State<MembershipWidget> createState() => _MembershipWidgetState();
}

class _MembershipWidgetState extends State<MembershipWidget> {
  bool expanded = false;

  @override
  void initState() {
    expanded = widget.opened;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              _widgetTitle(),
              _widgetContent(),
            ],
          ),
        ),
      ),
    );
  }

  _widgetTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                'StartDate: ${widget.membershipsBean!.startDate}',
                textScaleFactor: 1.0,
                style: TextStyle(fontSize: 20),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              icon: Icon(
                expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: ColorApp.mainColor,
              ),
            )
          ],
        ),
        Text(
          'EndDate: ${widget.membershipsBean!.endDate.toString()}',
          textScaleFactor: 1.0,
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  _widgetContent() {
    return Visibility(
      visible: expanded,
      child: Column(
        children: <Widget>[
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 3,
              thickness: 0.5,
              color: Color(0xFF707070),
            ),
            itemCount: 1,
            itemBuilder: (context, index) {
              var item = widget.membershipsBean;
              var regExpHtml = RegExp('.*\\<[^>]+>.*');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${item!.name}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  regExpHtml.hasMatch(item.description)
                      ? Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        )
                      : const SizedBox(),
                  regExpHtml.hasMatch(item.description)
                      ? Html(
                          data: item.description,
                          style: {
                            'body': Style(
                              fontSize: FontSize(14),
                            )
                          },
                        )
                      : Text(
                          'Description: ${item.description}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                  const SizedBox(height: 8),
                  Text(
                    'Cycle Period: ${item.cyclePeriod}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Initial payment: ${item.initialPayment}\$',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Billing amount: ${item.billingAmount}\$',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${item.status}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Center(
              child: Text(
                '#${widget.membershipsBean!.subscriptionId}',
                textScaleFactor: 1.0,
                style: TextStyle(color: Color(0xFF999999), fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
