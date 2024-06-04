import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_purchase_app/screens/login_screen.dart';
import 'package:food_purchase_app/stores/food_store.dart';
import '../service/auth_service.dart';
import 'checkout_screen.dart';

class MainScreen extends StatelessWidget {
  final FoodStore store = FoodStore();
  final AuthService _authService = AuthService();

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!_authService.isAuthenticated()) {
      // redirect to login screen if not authenticated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }

    store.loadFoodItems();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Food Items'),
        backgroundColor: Colors.greenAccent,
        actions: [
          Observer(
            builder: (_) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(store: store),
                        ),
                      );
                    },
                  ),
                  if (store.shoppingBasket.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${store.shoppingBasket.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (store.foodItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: store.foodItems.length,
                itemBuilder: (context, index) {
                  final item = store.foodItems[index];
                  return GestureDetector(
                    onTap: () {
                      store.addToBasket(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('${item.title} added to basket')),
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Image.network(
                              item.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image,
                                    size: 150);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.title.length > 50
                                  ? '${item.title.substring(0, 50)}...'
                                  : item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
