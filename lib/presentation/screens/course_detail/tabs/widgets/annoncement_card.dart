import 'package:flutter/material.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/widgets/webview_widgets/web_view_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class AnnoncementCard extends StatefulWidget {
  const AnnoncementCard({Key? key, this.annoncementUrl}) : super(key: key);

  final String? annoncementUrl;

  @override
  State<AnnoncementCard> createState() => _AnnoncementCardState();
}

class _AnnoncementCardState extends State<AnnoncementCard> {
  bool showMore = false;

  /// Height of annoncement content
  double? contentHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.annoncementUrl == null || widget.annoncementUrl!.isEmpty) return Center();

    double webContainerHeight;

    if (contentHeight != null && showMore) {
      webContainerHeight = contentHeight!;
    } else {
      webContainerHeight = 160;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Text(
            localizations.getLocalization('annoncement_title'),
            textScaleFactor: 1.0,
            style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                  color: ColorApp.dark,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: webContainerHeight),
          child: WebViewBaseWidget(
            url: widget.annoncementUrl,
            onPageFinished: (Object data) {
              contentHeight = double.parse(data.toString());
            },
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  showMore = !showMore;
                });
              },
              child: Text(
                showMore
                    ? localizations.getLocalization('show_less_button')
                    : localizations.getLocalization('show_more_button'),
                textScaleFactor: 1.0,
                style: TextStyle(color: ColorApp.mainColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
