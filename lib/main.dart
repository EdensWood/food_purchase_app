import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_purchase_app/firebase_options.dart';
import 'package:food_purchase_app/stores/food_store.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:food_purchase_app/screens/main_screen.dart';
import 'package:food_purchase_app/screens/checkout_screen.dart';
import 'package:food_purchase_app/screens/success_screen.dart';
import 'package:food_purchase_app/screens/login_screen.dart';

import 'model/auth_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  Hive.registerAdapter(AuthModelAdapter());

  await Hive.openBox<AuthModel>('authBox');
  await Hive.openBox<String>('userBox');

  runApp(const FoodPurchaseApp());
}

class FoodPurchaseApp extends StatelessWidget {
  const FoodPurchaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Purchase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/main': (context) => MainScreen(),
        '/checkout': (context) => CheckoutScreen(store: FoodStore()),
        '/success': (context) => const SuccessScreen(),
      },
    );
  }
}
