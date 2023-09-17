import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewBaseWidget extends StatefulWidget {
  const WebViewBaseWidget({
    Key? key,
    required this.url,
    required this.onPageFinished,
    this.isWebViewPage = false,
  }) : super(key: key);

  final String? url;

  final Function(Object data) onPageFinished;

  final bool isWebViewPage;

  @override
  State<WebViewBaseWidget> createState() => _WebViewCustomWidgetState();
}

class _WebViewCustomWidgetState extends State<WebViewBaseWidget> {
  final WebViewController webViewController = WebViewController();

  @override
  void initState() {
    if (widget.url != null && widget.url!.isNotEmpty && !widget.isWebViewPage) {
      webViewController
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadHtmlString(widget.url!)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) async {
              var height =
                  await webViewController.runJavaScriptReturningResult('document.documentElement.scrollHeight;');

              widget.onPageFinished(height);
            },
          ),
        );
    } else {
      webViewController
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(widget.url!))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) async {
              var height = await webViewController.runJavaScriptReturningResult('document.body.offsetHeight');

              widget.onPageFinished(height);
            },
          ),
        );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: webViewController,
    );
  }
}
