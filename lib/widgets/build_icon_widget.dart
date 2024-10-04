import 'package:flutter/material.dart';

class BuildIconWidget extends StatelessWidget {
  final Icon? icon;
  final double? size;
  final Color? color;
  final VoidCallback? onPressed;

  const BuildIconWidget({
    Key? key,
    this.icon,
    this.size,
    this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ??
          Icon(Icons.cancel_outlined,
              size: size ?? 30, color: color ?? Colors.white),
      onPressed: onPressed ?? () {},
    );
  }
}
