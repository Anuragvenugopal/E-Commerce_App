import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:login_page_auth/payment_status.dart';
import 'package:login_page_auth/product_view_page.dart';
import 'package:login_page_auth/utils/app_colors.dart';
import 'package:login_page_auth/widgets/Custom_elevated_Button.dart';
import 'package:login_page_auth/widgets/build_icon_widget.dart';
import 'package:login_page_auth/widgets/build_text_widget.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'Models/cart_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Box<CartModel> cartBox;
  late Razorpay razorpay;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<CartModel>('cart');
    razorpay = Razorpay();

    // Set up event handlers
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  // Error handler
  void errorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: BuildTextWidget(
        text: response.message ?? 'Payment error',
        color: Colors.white,
      ),
      backgroundColor: Colors.red,
    ));
  }

  // Success handler
  void successHandler(PaymentSuccessResponse response) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PaymentStatus(),
      ),
    );
  }

  // External wallet handler
  void externalWalletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: BuildTextWidget(
        text: 'External wallet used: ${response.walletName}',
        color: Colors.white,
      ),
      backgroundColor: Colors.green,
    ));
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var i = 0; i < cartBox.length; i++) {
      final item = cartBox.getAt(i);
      if (item != null) {
        total += (double.tryParse(item.price) ?? 0.0) * item.quantity;
      }
    }
    return total;
  }

  double calculateGstPrice() {
    const double gstRate = 0.18;
    double total = 0.0;
    for (var i = 0; i < cartBox.length; i++) {
      final item = cartBox.getAt(i);
      if (item != null) {
        double itemPrice = double.tryParse(item.price) ?? 0.0;
        total += itemPrice * item.quantity;
      }
    }
    return total * gstRate;
  }

  double calculateCGSTPrice() {
    const double cgstRate = 0.09;
    double total = 0.0;

    for (var i = 0; i < cartBox.length; i++) {
      final item = cartBox.getAt(i);
      if (item != null) {
        double itemPrice = double.tryParse(item.price) ?? 0.0;
        total += itemPrice * item.quantity;
      }
    }
    return total * cgstRate;
  }

  double calculateUTGSTPrice() {
    const double cgstRate = 0.09;
    double total = 0.0;

    for (var i = 0; i < cartBox.length; i++) {
      final item = cartBox.getAt(i);
      if (item != null) {
        double itemPrice = double.tryParse(item.price) ?? 0.0;
        total += itemPrice * item.quantity;
      }
    }
    return total * cgstRate;
  }

  void updateQuantity(int index, int delta) {
    setState(() {
      final item = cartBox.getAt(index);
      if (item != null) {
        item.quantity += delta;
        if (item.quantity <= 0) {
          cartBox.deleteAt(index);
        } else {
          item.save();
        }
      }
    });
  }

  // Open checkout
  void openCheckout() {
    var options = {
      "key": "rzp_test_waeUUkXGdhnmoe",
      "amount":
          ((calculateTotalPrice() + calculateGstPrice()) * 100).toString(),
      "name": "Your Company Name",
      "description": "Payment for cart items",
      "timeout": "180",
      "currency": "INR",
      "prefill": {
        "contact": "",
        "email": "test@abc.com",
      }
    };
    razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: BuildTextWidget(
          text: 'My Cart',
          color: AppColors.black,
        ),
      ),
      body: cartBox.isEmpty
          ? Center(
              child: BuildTextWidget(
                text: 'No Cart added yet.',
                color: AppColors.grey,
                fontSize: 18,
              ),
            )
          : ListView.builder(
              itemCount: cartBox.length,
              itemBuilder: (context, index) {
                final item = cartBox.getAt(index);
                if (item == null) {
                  return SizedBox.shrink();
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductViewPage(
                          image: item.image,
                          title: item.title,
                          description: item.description,
                          rating: item.rating,
                          price: item.price,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.light_shade,
                              ),
                              child: Image.network(
                                item.image,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.button_color,
                                        strokeWidth: 3,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BuildTextWidget(
                                  text: item.title,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                SizedBox(height: 5.0),
                                BuildTextWidget(
                                  text:
                                      '₹${(double.tryParse(item.price) ?? 0.0 * item.quantity).toStringAsFixed(2)}',
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    BuildIconWidget(
                                      icon: Icon(
                                        Icons.remove,
                                        color: AppColors.button_color,
                                      ),
                                      color: AppColors.button_color,
                                      onPressed: () =>
                                          updateQuantity(index, -1),
                                    ),
                                    // IconButton(
                                    //   icon: Icon(Icons.remove,
                                    //       color: AppColors.button_color),
                                    //   onPressed: () =>
                                    //       updateQuantity(index, -1),
                                    // ),
                                    BuildTextWidget(
                                      text: item.quantity.toString(),
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    BuildIconWidget(
                                      icon: Icon(
                                        Icons.add,
                                        color: AppColors.button_color,
                                      ),
                                      onPressed: () => updateQuantity(index, 1),
                                    ),
                                    // IconButton(
                                    //   icon: Icon(Icons.add,
                                    //       color: AppColors.button_color),
                                    //   onPressed: () => updateQuantity(index, 1),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            BuildIconWidget(
                                icon: Icon(
                                  Icons.delete,
                                  color: AppColors.button_color,
                                ),
                                color: AppColors.button_color,
                                size: 30,
                                onPressed: () {
                                  setState(() {
                                    cartBox.deleteAt(index);
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BuildTextWidget(
                    text: 'Total Price:',
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  BuildTextWidget(
                    text:
                        '₹${(calculateTotalPrice() + calculateGstPrice()).toStringAsFixed(2)}',
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ],
              ),
              ExpansionTile(
                collapsedBackgroundColor: AppColors.transparent,
                title: BuildTextWidget(
                  text: 'Price Details:',
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                backgroundColor: AppColors.white,
                childrenPadding: EdgeInsets.all(16.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildTextWidget(
                        text: 'Delivery Charge:',
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      BuildTextWidget(
                        text: 'Free Delivery',
                        color: AppColors.button_color,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildTextWidget(
                        text: 'CGST(9%)',
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      BuildTextWidget(
                        text: '₹${calculateCGSTPrice().toStringAsFixed(2)}',
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildTextWidget(
                        text: 'CGST/UTGST(9%)',
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      BuildTextWidget(
                        text: '₹${calculateUTGSTPrice().toStringAsFixed(2)}',
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildTextWidget(
                        text: 'Goods & Service Tax(18%)',
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      BuildTextWidget(
                        text: '₹${calculateGstPrice().toStringAsFixed(2)}',
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child:
                  CustomElevatedButton(
                    text: 'Continue',
                    onPressed: cartBox.isEmpty ? null : () => openCheckout(),
                    backgroundColor: cartBox.isEmpty ? AppColors.grey : AppColors.golden,
                    textColor: AppColors.white,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    width: 150.0,
                    height: 50.0,
                    // isEnabled: cartBox.isNotEmpty,
                  ),


                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
