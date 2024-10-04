import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_page_auth/main.dart';
import 'package:login_page_auth/utils/app_colors.dart';
import 'package:login_page_auth/widgets/Custom_elevated_Button.dart';
import 'package:login_page_auth/widgets/build_Text_widget.dart';
import 'package:login_page_auth/widgets/build_bottom_navigation_bar_widget.dart';
import 'package:lottie/lottie.dart';


class PaymentStatus extends StatefulWidget {
  const PaymentStatus({super.key});

  @override
  State<PaymentStatus> createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/payment_status.json',
            repeat: false,
          ),
          SizedBox(height: 20),
          BuildTextWidget(
            text: 'Payment is Successful',
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomElevatedButton(
              text: 'Done',
              onPressed: () { cartBox.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BuildBottomNavigationBarWidget(),
                ),
              );
              },
              backgroundColor: AppColors.button_color,
              textColor: Colors.white,
              textStyle: TextStyle(fontWeight: FontWeight.bold),
              width: 150.0,
              height: 50.0,
            ),
          )

        ],
      ),
    );
  }
}
