import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key, this.loaderColor}) : super(key: key);

  final Color? loaderColor;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Center(
        child: CupertinoActivityIndicator(
          color: loaderColor ?? Colors.white,
        ),
      );
    } else {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(loaderColor ?? Colors.white),
          ),
        ),
      );
    }
  }
}
