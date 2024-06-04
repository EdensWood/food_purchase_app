import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_purchase_app/stores/food_store.dart';

class CheckoutScreen extends StatelessWidget {
  final FoodStore store;

  const CheckoutScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.greenAccent,
        actions: const [Icon(Icons.shopping_cart)],
      ),
      body: Observer(
        builder: (_) {
          if (store.shoppingBasket.isEmpty) {
            return const Center(child: Text('Your basket is empty.'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: store.shoppingBasket.length,
                    itemBuilder: (context, index) {
                      final item = store.shoppingBasket[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                              item.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 50);
                              },
                            ),
                          ),
                          title: Text(
                            item.title.length > 30
                                ? '${item.title.substring(0, 30)}...'
                                : item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text('Quantity: ${item.quantity}'),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await store.checkout();
                      Navigator.pushReplacementNamed(context, '/success');
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
