import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:login_page_auth/product_view_page.dart';
import 'package:login_page_auth/shopping_home_page.dart';
import 'package:login_page_auth/utils/app_colors.dart';
import 'package:login_page_auth/widgets/build_bottom_navigation_bar_widget.dart';
import 'package:login_page_auth/widgets/build_icon_widget.dart';
import 'package:login_page_auth/widgets/build_text_widget.dart';
import 'Models/favorite_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({
    Key? key,
  }) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Box<favoriteModel> favoriteBox;

  @override
  void initState() {
    super.initState();
    favoriteBox = Hive.box<favoriteModel>('favorites');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: BuildIconWidget(
            icon: Icon(Icons.arrow_back),
            color: AppColors.black,
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuildBottomNavigationBarWidget(),
                  ));
            },
          ),
          onPressed: () {},
        ),
        title: BuildTextWidget(
          text: 'Favorites',
          color: AppColors.black,
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: favoriteBox.isEmpty
          ? Center(
              child: BuildTextWidget(
              text: 'No favorites added yet.',
              fontSize: 18,
              color: AppColors.grey,
            ))
          : ListView.builder(
              itemCount: favoriteBox.length,
              itemBuilder: (context, index) {
                final item = favoriteBox.getAt(index) as favoriteModel;

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
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      color: AppColors.light_shade,
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
                        ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(8.0),
                          ),
                          child: Image.network(
                            item.image,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BuildTextWidget(
                                  text: item.title,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                SizedBox(height: 5.0),
                                BuildTextWidget(
                                  text: '₹${item.price}',
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ],
                            ),
                          ),
                        ),
                        BuildIconWidget(
                          icon: Icon(
                            Icons.favorite,
                            color: AppColors.red,
                          ),
                          color: AppColors.red,
                          size: 30,
                          onPressed: () {
                            setState(() {
                              favoriteBox.deleteAt(index);
                            });
                          },
                        )
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.favorite,
                        //     color: AppColors.red,
                        //     size: 30,
                        //   ),
                        //   onPressed:
                        //       () {
                        //     setState(() {
                        //       favoriteBox.deleteAt(index);
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
