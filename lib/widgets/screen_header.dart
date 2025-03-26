import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class ScreenHeader extends StatelessWidget {
  final String titleKey;
  final Color backgroundColor;
  final Color textColor;
  final double height;

  const ScreenHeader({
    Key? key,
    required this.titleKey,
    this.backgroundColor = const Color(
      0xFF74C69D,
    ), // Medium light green from theme
    this.textColor = Colors.white,
    this.height = 60.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(
        child: Text(
          titleKey.tr(context),
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
