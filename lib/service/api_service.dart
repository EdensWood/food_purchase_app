import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/food_item.dart';

class ApiService {
  final String apiKey = '402b09314d8445e984aa177ecd7b8a29';
  final String baseUrl = 'https://api.spoonacular.com/food/products/search';

  Future<List<FoodItem>> fetchFoodItems(
      {String query = '', int number = 100, int offset = 0}) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?query=$query&number=$number&offset=$offset&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<FoodItem> items = (data['products'] as List)
          .map((item) => FoodItem.fromJson(item))
          .toList();
      return items;
    } else {
      throw Exception('Failed to load food items');
    }
  }

  Future<List<FoodItem>> fetchAllFoodItems() async {
    List<FoodItem> allItems = [];
    int offset = 0;
    int number =
        100; // You can adjust this to control the number of items per request
    bool hasMoreItems = true;

    while (hasMoreItems) {
      final items = await fetchFoodItems(number: number, offset: offset);
      if (items.isEmpty) {
        hasMoreItems = false;
      } else {
        allItems.addAll(items);
        offset += number;
      }
    }

    return allItems;
  }
}
