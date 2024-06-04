import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';


import '../model/food_item.dart';
import '../service/api_service.dart';
import '../service/isar_service.dart';

part 'food_store.g.dart';

class FoodStore = _FoodStore with _$FoodStore;

abstract class _FoodStore with Store {
  final ApiService apiService = ApiService();
  final IsarService isarService = IsarService();

  @observable
  ObservableList<FoodItem> foodItems = ObservableList<FoodItem>();

  @observable
  ObservableList<FoodItem> shoppingBasket = ObservableList<FoodItem>();

  @action
  Future<void> loadFoodItems() async {
    final items = await isarService.getFoodItems();
    if (items.isEmpty) {
      final fetchedItems = await apiService.fetchAllFoodItems();
      await isarService.saveFoodItems(fetchedItems);
      foodItems.addAll(fetchedItems);
    } else {
      foodItems.addAll(items);
    }
  }

  @action
  void addToBasket(FoodItem item) {
    final existingItem = shoppingBasket.firstWhereOrNull(
        (basketItem) => basketItem.id == item.id,
    );

    if (existingItem != null) {
      final index = shoppingBasket.indexOf(existingItem);
      shoppingBasket[index] = existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else{
      shoppingBasket.add(item.copyWith(quantity: 1));
    }

  }

  @action
  Future<void> checkout() async {
    final dio = Dio();

    final items = shoppingBasket.map((item) => {
      'id': item.id,
      'title': item.title,
      'quantity': item.quantity,
    }).toList();

    try {
      final response = await dio.post(
        'https://jsonplaceholder.typicode.com/posts', //Dummy endpoint
        data: {
          'items': items,
          'total': shoppingBasket.length,
        },
      );

      if (response.statusCode == 201) {
        print('Checkout successful: ${response.data}');
        shoppingBasket.clear();
      } else {
        print('Failed to checkout: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during checkout: $e');
    }
  }
}
