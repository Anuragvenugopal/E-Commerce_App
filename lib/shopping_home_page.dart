import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_carousel_slider/asset_image_carousel_slider.dart';
import 'package:login_page_auth/product_view_page.dart';
import 'package:login_page_auth/utils/app_colors.dart';
import 'package:login_page_auth/widgets/build_Text_widget.dart';
import 'package:login_page_auth/widgets/build_icon_widget.dart';

import 'Models/get_product_resposnse_Model.dart';

class ShoppingHomePage extends StatefulWidget {
  const ShoppingHomePage({super.key});

  @override
  State<ShoppingHomePage> createState() => _ShoppingHomePageState();
}

class _ShoppingHomePageState extends State<ShoppingHomePage> {
  bool isLoading = false;
  bool isCategoryLoading = false;
  bool isSearchLoading = false;
  String searchQuery = '';
  String selectedCategory = '';

  ProductResponseModel? getProductResponseModel;
  List<dynamic>? getCategoryModel;
  List<Product>? getSearchProductsModel;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await Dio().get('https://dummyjson.com/products?limit=100&skip=0');
      getProductResponseModel = ProductResponseModel.fromJson(response.data);
    } catch (e) {
      print('Error fetching products: $e');
    }
    setState(() {
      isLoading = false;
    });
  }
  Future<void> updateData() async {
    if (selectedCategory == 'All') {
      await getData();
    } else if (selectedCategory.isNotEmpty) {
      await getProductsByCategory(
          selectedCategory);
    }
  }
  Future<void> getCategory() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await Dio().get('https://dummyjson.com/products/category-list');
      getCategoryModel = response.data;
    } catch (e) {
      print('Error fetching categories: $e');
    }
    setState(() {
      isLoading = false;
    });
  }
  Future<void> getSearchProducts(String query) async {
    setState(() {
      isSearchLoading = true;
    });
    try {
      final response =
          await Dio().get('https://dummyjson.com/products/search?q=$query');
      final List<dynamic> data = response.data['products'];
      getSearchProductsModel =
          data.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      print('Error searching products: $e');
    }
    setState(() {
      isSearchLoading = false;
    });
  }
  Future<void> getProductsByCategory(String category) async {
    setState(() {
      isCategoryLoading = true;
    });
    try {
      final response =
          await Dio().get('https://dummyjson.com/products/category/$category');
      getProductResponseModel = ProductResponseModel.fromJson(response.data);
    } catch (e) {
      print('Error fetching products by category: $e');
    } finally {
      setState(() {
        isCategoryLoading = false;
      });
    }
  }

  List<String> imageList = [
    "assets/images/image1.jpg",
    "assets/images/image5.jpg",
    "assets/images/images2.jpg",
  ];

  @override
  void initState() {
    super.initState();
    getData();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: isLoading && selectedCategory.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 38,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.appbar_color,
                      ),
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: AppColors.grey),
                            border: InputBorder.none,
                            icon: BuildIconWidget(
                              icon: Icon(Icons.search_rounded),
                              color: AppColors.grey,
                            ),
                            suffixIcon: BuildIconWidget(
                              icon: Icon(Icons.cancel_outlined),
                              color: AppColors.grey,
                              onPressed: () {
                                setState(() {
                                  searchQuery = '';
                                });
                                getData();
                              },
                            ),
                          ),
                          style: TextStyle(color: AppColors.grey),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                            if (value.isNotEmpty) {
                              getSearchProducts(value);
                            } else {
                              getData();
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    AssetImageCarouselSlider(
                      items: imageList,
                      imageHeight: 200,
                      dotColor: AppColors.light_shade,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (getCategoryModel?.length ?? 0) + 1,
                        itemBuilder: (context, index) {
                          final category = index == 0
                              ? 'All'
                              : getCategoryModel?[index - 1] ?? '';

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child:
                            ChoiceChip(
                              backgroundColor: AppColors.light_shade,
                              label: BuildTextWidget(
                                text: category,
                                color: AppColors.black,
                              ),
                              selected: selectedCategory == category,
                              onSelected: (isSelected) {
                                setState(() {
                                  selectedCategory = isSelected ? category : '';
                                });
                                updateData();
                              },
                              selectedColor: AppColors.light_shade,
                            ),
                          );
                        },
                      ),
                    ),
                    isSearchLoading || isCategoryLoading
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: searchQuery.isEmpty
                                ? getProductResponseModel?.products?.length ?? 0
                                : getSearchProductsModel?.length ?? 0,
                            itemBuilder: (context, index) {
                              final item = searchQuery.isEmpty
                                  ? getProductResponseModel!.products![index]
                                  : getSearchProductsModel![index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductViewPage(
                                        image: item.images?.first ?? '',
                                        title: item.title ?? '',
                                        description: item.description ?? '',
                                        rating: item.rating?.toString() ?? '',
                                        price: item.price?.toString() ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(8.0)),
                                          child: Image.network(
                                            item.thumbnail ?? '',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color:
                                                        AppColors.button_color,
                                                    strokeWidth: 4,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: BuildTextWidget(
                                          text: item.title ?? '',
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            BuildTextWidget(
                                              text: 'Price: ₹ ',
                                              color: AppColors.black,
                                              fontSize: 14.0,
                                            ),
                                            BuildTextWidget(
                                              text:
                                                  item.price?.toString() ?? '',
                                              color: AppColors.black,
                                              fontSize: 14.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    if (searchQuery.isNotEmpty &&
                        (getSearchProductsModel?.isEmpty ?? true))
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: BuildTextWidget(
                            text: 'No products found',
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
