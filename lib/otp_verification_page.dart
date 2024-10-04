import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:login_page_auth/utils/app_colors.dart';
import 'package:login_page_auth/widgets/Custom_elevated_Button.dart';
import 'package:login_page_auth/widgets/build_Text_widget.dart';
import 'package:login_page_auth/widgets/build_bottom_navigation_bar_widget.dart';
import 'package:new_pinput/new_pinput.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpVerificationPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late String verificationId;
  late OtpTimerButtonController controller;

  @override
  void initState() {
    super.initState();
    verificationId = widget.verificationId;
    controller = OtpTimerButtonController();
  }

  Future<void> verifyOTP(String otp) async {
    setState(() {
      isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BuildBottomNavigationBarWidget()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP verification failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resendOTP() async {
    if (widget.phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number is empty. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String formattedPhoneNumber = '+91${widget.phoneNumber}';

    try {
      print('Resending OTP to: $formattedPhoneNumber');

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification failed: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP has been resent'),
              backgroundColor: Colors.green,
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        forceResendingToken: null,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/OTP 1.svg',
                        width: 280,
                        height: 280,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                BuildTextWidget(
                  text: 'OTP Verification',
                  color: AppColors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 30),
                BuildTextWidget(
                  text: 'Enter the OTP sent to your number',
                  color: AppColors.grey,
                  fontSize: 16,
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      controller: pinController,
                      focusNode: focusNode,
                      length: 6,
                      androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsUserConsentApi,
                      listenForMultipleSmsOnAndroid: true,
                      validator: (value) {
                        return value != null && value.length == 6
                            ? null
                            : 'Please enter a valid 6-digit OTP';
                      },
                      onCompleted: (pin) async {
                        await verifyOTP(pin);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: AppColors.button_color,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomElevatedButton(
                          text: 'Verify',
                          onPressed: () async {
                            final otp = pinController.text;
                            if (otp.isNotEmpty && otp.length == 6) {
                              await verifyOTP(otp);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please enter the 6-digit OTP'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          backgroundColor: AppColors.button_color,
                          width: 320,
                          height: 55,
                          icon: Icons.check,
                          iconSize: 24,
                          textColor: Colors.white,
                        ),
                      ),
                OtpTimerButton(
                  controller: controller,
                  onPressed: () {
                    resendOTP();
                  },
                  text:Text('Resend OTP'),
                  duration: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
