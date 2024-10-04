import 'package:flutter/material.dart';
import 'package:login_page_auth/utils/app_colors.dart';

class BuildTextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final double? maxLines;
  final dynamic TextOverFlow;

  const BuildTextWidget({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.maxLines,
    this.TextOverFlow, TextStyle? textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? AppColors.black,
        fontSize: fontSize,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
      ),
    );
  }
}
