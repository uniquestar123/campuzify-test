import 'package:flutter/material.dart';

/// Единый стиль modal bottom sheet
Future<T?> showBaseModalBottomSheet<T>({
  required BuildContext context,
  required Widget content,
  bool addKeyboardPadding = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.35),
    clipBehavior: Clip.hardEdge,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16.0),
      ),
    ),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          children: [
            const HeaderBottomSheet(),
            content,
          ],
        ),
      );
    },
  );
}

class HeaderBottomSheet extends StatelessWidget {
  const HeaderBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4.0),
          height: 4.0,
          width: 32.0,
          decoration: BoxDecoration(
            color: Color(0xFFDDE1E3),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
      ],
    );
  }
}
