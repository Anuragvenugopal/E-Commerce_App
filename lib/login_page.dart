import 'package:flutter/material.dart';
import 'package:login_page_auth/widgets/Custom_elevated_Button.dart';
import 'package:login_page_auth/widgets/custom_text_form_Field_widget.dart';
import 'package:login_page_auth/utils/app_colors.dart';
import 'package:login_page_auth/widgets/build_Text_widget.dart';
import 'package:login_page_auth/widgets/build_bottom_navigation_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'otp_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController phoneNumberController = TextEditingController();
    String selectedLanguage = 'English';
  bool isPhoneLoading = false;
  bool isGoogleLoading = false;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    String formattedPhoneNumber = '+91$phoneNumber';

    setState(() {
      isPhoneLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          setState(() {
            isPhoneLoading = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BuildBottomNavigationBarWidget(),
            ),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isPhoneLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification failed: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
          // Additional handling for specific errors
          if (e.code == 'billing-not-enabled') {
            // Example handling for the billing error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Phone authentication is not enabled. Please enable billing for this Firebase project.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            isPhoneLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isPhoneLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        isPhoneLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isGoogleLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BuildBottomNavigationBarWidget(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isGoogleLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: BuildTextWidget(
                        text: 'Sign In to Shop Direct',
                        color: AppColors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 120),
                          CustomTextFormField(
                            controller: phoneNumberController,
                            hintText: 'Phone Number',
                            prefixText: '+91 ',
                            onClear: () {
                              setState(() {
                                phoneNumberController.clear();
                              });
                            },
                            isPhoneNumber: true,
                          ),
                          SizedBox(height: 20),
                          BuildTextWidget(
                            text: 'You will receive a 6 digit code for phone\n'
                                'number verification',
                            color: AppColors.grey,
                            fontSize: 15,
                          ),
                          SizedBox(height: 50),
                          CustomElevatedButton(
                            text: 'Continue',
                            isLoading: isPhoneLoading,
                            onPressed: () async {
                              if (isPhoneLoading) return;

                              if (phoneNumberController.text.length == 10) {
                                await verifyPhoneNumber(
                                    phoneNumberController.text);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please enter a valid 10-digit phone number.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            backgroundColor: AppColors.button_color,
                            width: 100,
                            height: 60,
                          ),
                          SizedBox(height: 20),
                          CustomElevatedButton(
                            text: 'Sign in with Google',
                            isLoading: isGoogleLoading,
                            onPressed:
                                () async {
                              if (isGoogleLoading) return;
                              await signInWithGoogle();
                            },
                            backgroundColor: AppColors.white,
                            textColor: AppColors.black,
                            iconUrl:
                            'https://static-00.iconduck.com/assets.00/google-icon-512x512-wk1c10qc.png',
                            width: 100,
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
