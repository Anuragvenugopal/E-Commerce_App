import 'package:hive/hive.dart';

part 'favorite_model.g.dart';

@HiveType(typeId: 0)
class favoriteModel extends HiveObject {
  @HiveField(0)
  final String image;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String rating;

  @HiveField(4)
  final String price;


  favoriteModel({
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
    required this.price,


  });
}
