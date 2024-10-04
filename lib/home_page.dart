import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_page_auth/login_page.dart';
import 'package:login_page_auth/utils/app_colors.dart';
import 'package:login_page_auth/widgets/Custom_elevated_Button.dart';
import 'package:login_page_auth/widgets/build_Text_widget.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroiund.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 110,
            left: 10,
            right: 50,
            child: Align(
              alignment: Alignment.topCenter,
              child: BuildTextWidget(
                text: 'Shopify',
                color: AppColors.button_color,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/Animation - 1725705004748 (3).json',
                      ),
                      Positioned(
                        bottom: 10,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ElevatedButton(
                            //   child: BuildTextWidget(
                            //       text: 'Sign In', color: AppColors.white),
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: AppColors.button_color,
                            //   ),
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => LoginPage(),
                            //       ),
                            //     );
                            //   },
                            // ),
                            CustomElevatedButton(
                              text: 'Sign In',
                              backgroundColor: AppColors.button_color,
                              width: 20,
                              height: 20,
                              textColor: AppColors.white,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            CustomElevatedButton(
                              text: 'Register',
                              backgroundColor: AppColors.white,
                              width: 20,
                              height: 20,
                              textColor: AppColors.button_color,
                              onPressed: () {
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(19.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          BuildTextWidget(
                            text:
                                ' Explore a wide range  of products from top brands',
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                          BuildTextWidget(
                            text: 'Shop sustainably with our Shopify app.',
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: BuildTextWidget(
                    text: 'skip>>',
                    color: AppColors.button_color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
