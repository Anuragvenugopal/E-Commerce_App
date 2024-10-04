import 'package:hive/hive.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 1)
class CartModel extends HiveObject {
  @HiveField(0)
  final String image;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String rating;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  final String price;

  CartModel({
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
    this.quantity = 1,
    required this.price,
  });
}
