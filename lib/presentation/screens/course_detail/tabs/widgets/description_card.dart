import 'package:flutter/material.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/widgets/webview_widgets/web_view_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class DescriptionCard extends StatefulWidget {
  const DescriptionCard({
    Key? key,
    required this.descriptionUrl,
    required this.scrollCallback,
  }) : super(key: key);

  final String? descriptionUrl;
  final VoidCallback scrollCallback;

  @override
  State<DescriptionCard> createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<DescriptionCard> {
  bool showMore = false;
  double? contentHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double webContainerHeight;

    if (contentHeight != null && showMore) {
      webContainerHeight = contentHeight!;
    } else {
      webContainerHeight = 160;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: webContainerHeight,
          ),
          child: WebViewBaseWidget(
            url: widget.descriptionUrl,
            onPageFinished: (Object data) async {
              contentHeight = double.parse(data.toString());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                showMore = !showMore;
                if (!showMore) widget.scrollCallback.call();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  showMore
                      ? localizations.getLocalization('show_less_button')
                      : localizations.getLocalization('show_more_button'),
                  textScaleFactor: 1.0,
                  style: TextStyle(color: ColorApp.mainColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
