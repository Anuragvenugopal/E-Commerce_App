import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_page_auth/utils/app_colors.dart';
import 'package:login_page_auth/widgets/build_Text_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: BuildTextWidget(
                  text: 'Profile Page', color: AppColors.black)),
        ],
      ),
    );
  }
}
