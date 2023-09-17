import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/screens/orders/orders_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebCheckoutScreenArgs {
  WebCheckoutScreenArgs(this.url);

  final String? url;
}

class WebCheckoutScreen extends StatelessWidget {
  static const String routeName = '/webCheckoutScreen';

  @override
  Widget build(BuildContext context) {
    final WebCheckoutScreenArgs args = ModalRoute.of(context)?.settings.arguments as WebCheckoutScreenArgs;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.getLocalization('checkout_title'),
          textScaleFactor: 1.0,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: WebCheckoutWidget(url: args.url),
    );
  }
}

class WebCheckoutWidget extends StatefulWidget {
  const WebCheckoutWidget({Key? key, required this.url});

  final String? url;

  @override
  State<StatefulWidget> createState() => WebCheckoutWidgetState();
}

class WebCheckoutWidgetState extends State<WebCheckoutWidget> {
  final WebViewController webViewController = WebViewController();

  @override
  void initState() {
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.url! + '&app=123'),
        headers: {'token': preferences.getString(PreferencesName.apiToken)!},
      )
      ..addJavaScriptChannel(
        'lmsEvent',
        onMessageReceived: (JavaScriptMessage result) {
          if (jsonDecode(result.message)['event_type'] == 'order_created') {
            if (jsonDecode(result.message)['payment_code'] == 'paypal') {
              openPaypalPayment(jsonDecode(result.message)['url']);
            } else {
              final future = Navigator.pushNamed(context, OrdersScreen.routeName);

              future.then((value) {
                Navigator.pop(context);
              });
            }
          }
          if (jsonDecode(result.message)['event_type'] == 'plan_order_created') {
            Navigator.of(context).pop();
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) async {},
        ),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: webViewController,
    );
  }

  void openPaypalPayment(url) {
    final future = Navigator.pushNamed(
      context,
      WebCheckoutScreen.routeName,
      arguments: WebCheckoutScreenArgs(url),
    );
    future.then((value) {
      Navigator.pop(context);
    });
  }
}
