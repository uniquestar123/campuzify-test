import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialItem extends StatelessWidget {
  const SocialItem({Key? key, this.url, required this.iconData}) : super(key: key);

  final String? url;
  final String iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: GestureDetector(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(url!))) {
            await launchUrl(Uri.parse(url!));
          } else {
            await showFlutterToast(title: localizations.getLocalization('user_page_not_found'));
          }
        },
        child: SizedBox(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            iconData,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
