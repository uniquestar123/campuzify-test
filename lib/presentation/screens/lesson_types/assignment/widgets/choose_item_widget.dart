import 'package:flutter/material.dart';

class ChooseItemWidget extends StatelessWidget {
  const ChooseItemWidget({
    super.key,
    required this.valueText,
    required this.iconData,
    required this.iconColor,
    required this.onTap,
  });

  final String valueText;

  final IconData iconData;

  final Color iconColor;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(
              iconData,
              color: iconColor,
            ),
            const SizedBox(width: 10.0),
            Text(
              valueText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
