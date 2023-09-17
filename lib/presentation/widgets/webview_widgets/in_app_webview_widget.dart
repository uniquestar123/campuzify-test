import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewBaseWidget extends StatefulWidget {
  const InAppWebViewBaseWidget({Key? key, this.url}) : super(key: key);

  final String? url;

  @override
  State<InAppWebViewBaseWidget> createState() => _InAppWebViewBaseWidgetState();
}

class _InAppWebViewBaseWidgetState extends State<InAppWebViewBaseWidget> {
  InAppWebViewController? webViewController;
  String? _convertedUrl;

  @override
  void initState() {
    validateUrl(widget.url);
    super.initState();
  }

  String? validateUrl(String? url) {
    RegExp exp = RegExp(r'(?:(?:https?|ftp)://)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

    if (url != null || url!.isNotEmpty) {
      Iterable<RegExpMatch> matches = exp.allMatches(url);

      matches.forEach((match) {
        _convertedUrl = url.substring(match.start, match.end);
      });
    }

    return _convertedUrl;
  }

  @override
  Widget build(BuildContext context) {
    Widget buildWebView = InAppWebView(
      initialData: InAppWebViewInitialData(data: widget.url!),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          javaScriptEnabled: true,
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ),
      ),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
    );

    if (_convertedUrl != null) {
      buildWebView = InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(_convertedUrl!)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          ),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      );
    }

    return buildWebView;
  }
}
