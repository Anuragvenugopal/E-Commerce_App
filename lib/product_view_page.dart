import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:login_page_auth/Cart_page.dart';
import 'package:login_page_auth/Models/cart_model.dart';
import 'package:login_page_auth/utils/app_colors.dart';
import 'package:login_page_auth/widgets/Custom_elevated_Button.dart';
import 'package:login_page_auth/widgets/build_icon_widget.dart';
import 'package:login_page_auth/widgets/build_text_widget.dart';
import 'Models/favorite_model.dart';

class ProductViewPage extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String rating;
  final String price;

  ProductViewPage({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
    required this.price,
  }) : super(key: key);

  @override
  _ProductViewPageState createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  late Box<favoriteModel> favoriteBox;
  late Box<CartModel> cartBox;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    favoriteBox = Hive.box<favoriteModel>('favorites');
    cartBox = Hive.box<CartModel>('cart');
    isFavorite = favoriteBox.containsKey(widget.title);
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        favoriteBox.put(
            widget.title,
            favoriteModel(
              image: widget.image,
              title: widget.title,
              description: widget.description,
              rating: widget.rating,
              price: widget.price,
            ));
      } else {
        favoriteBox.delete(widget.title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: BuildTextWidget(
          text: widget.title,
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColors.white,
        actions: [
          BuildIconWidget(
            onPressed: toggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.red : AppColors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.image,
                height: 400,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: SizedBox(
                        height: 400,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.button_color,
                            strokeWidth: 4.0,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              Row(
                children: [
                  BuildIconWidget(
                    icon: Icon(
                      Icons.star,
                      color: AppColors.yellow,
                    ),
                    size: 50,
                  ),
                  BuildTextWidget(
                    text: widget.rating,
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: 16),
              BuildTextWidget(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                text: widget.title,
                color: AppColors.black,
              ),
              SizedBox(height: 10),
              BuildTextWidget(
                fontWeight: FontWeight.normal,
                fontSize: 18.0,
                text: widget.description,
                color: AppColors.grey,
                maxLines: null,
              ),
              SizedBox(height: 8),
              BuildTextWidget(
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                text: '₹${widget.price}',
                color: AppColors.black,
                maxLines: null,
              ),
              SizedBox(height: 50),
              SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomElevatedButton(
                    text: 'Add to Cart',
                    isLoading: false,
                    onPressed: () {
                      cartBox.put(
                        widget.title,
                        CartModel(
                          image: widget.image,
                          title: widget.title,
                          description: widget.description,
                          rating: widget.rating,
                          quantity: 1,
                          price: widget.price,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CartPage()),
                      );
                    },
                    backgroundColor: AppColors.button_color,
                    textColor: AppColors.white,
                    width: 100,
                    height: 100,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
