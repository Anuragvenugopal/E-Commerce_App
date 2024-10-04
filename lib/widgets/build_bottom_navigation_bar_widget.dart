
import 'package:flutter/material.dart';
import 'package:login_page_auth/Cart_page.dart';
import 'package:login_page_auth/favorite_page.dart';
import 'package:login_page_auth/profile_page.dart';
import 'package:login_page_auth/shopping_home_page.dart';
import 'package:login_page_auth/utils/app_colors.dart';

class BuildBottomNavigationBarWidget extends StatefulWidget {
  @override
  _BuildBottomNavigationBarWidgetState createState() =>
      _BuildBottomNavigationBarWidgetState();
}

class _BuildBottomNavigationBarWidgetState
    extends State<BuildBottomNavigationBarWidget> {
  int currentIndex = 0;
  final List<Widget> screens = [
    ShoppingHomePage(),
    FavoritePage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.button_color,
          ),
          padding: EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    Icons.home_rounded,0,),
                  _buildNavItem(Icons.favorite_border, 1),
                  _buildNavItem(Icons.shopping_cart, 2),
                  _buildNavItem(Icons.person, 3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Colors.transparent,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(12.0),
        child: Icon(
          icon,
          color: Colors.white,
          size: 25.0,
        ),
      ),
    );
  }
}
