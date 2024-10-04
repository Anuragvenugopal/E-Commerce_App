import 'package:flutter/material.dart';
import 'package:login_page_auth/widgets/build_Text_widget.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double? iconSize;
  final String? iconUrl;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double width;
  final double height;
  final bool isEnabled;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
    required this.backgroundColor,
    this.textColor = Colors.white,
    this.icon,
    this.iconSize,
    this.iconUrl,
    this.padding,
    this.textStyle,
    this.width = 150.0,
    this.height = 50.0,
    this.isEnabled = true, // Default value for isEnabled
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(width, height),
        padding: padding ?? EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: isLoading || !isEnabled ? null : onPressed,
      child: isLoading
          ? CircularProgressIndicator(
        color: textColor,
        strokeWidth: 3,
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: textColor, size: iconSize),
          if (icon != null && iconUrl != null) SizedBox(width: 8),
          if (iconUrl != null)
            Image.network(
              iconUrl!,
              width: 100,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: textColor);
              },
            ),
          if (iconUrl != null || icon != null) SizedBox(width: 10),
          BuildTextWidget(
            text: text,
            color: textColor,
            textStyle: textStyle,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
