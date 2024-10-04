import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_page_auth/utils/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String prefixText;
    final bool isPhoneNumber;
  final VoidCallback onClear;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixText,
    required this.onClear,
    this.isPhoneNumber = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: AppColors.white,
        filled: true,
        hintText: hintText,
        prefixText: prefixText,
        prefixStyle: TextStyle(color: AppColors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.cancel_outlined,
            color: AppColors.grey,
          ),
          onPressed: onClear,
        ),
      ),
      keyboardType: isPhoneNumber ? TextInputType.phone : TextInputType.text,
      inputFormatters: isPhoneNumber
          ? [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ]
          : [],
    );
  }
}
