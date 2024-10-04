import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:login_page_auth/home_page.dart';

import 'package:login_page_auth/widgets/build_bottom_navigation_bar_widget.dart';
import 'Models/cart_model.dart';
import 'Models/favorite_model.dart';
import 'firebase_options.dart';

final favoriteBox = Hive.box<favoriteModel>('favorites');
final cartBox = Hive.box<CartModel>('cart');


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await Hive.initFlutter();

  Hive.registerAdapter(favoriteModelAdapter());
  Hive.registerAdapter(CartModelAdapter());


  await Hive.openBox<favoriteModel>('favorites');
  await Hive.openBox<CartModel>('cart');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
