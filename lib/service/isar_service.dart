import 'package:food_purchase_app/model/food_item.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = _initDB();
  }

  Future<Isar> _initDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [FoodItemSchemaSchema],
        directory: dir.path,
      );
      return isar;
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveFoodItems(List<FoodItem> items) async {
    final isar = await db;
    final foodItems = items.map((item) => FoodItemSchema.fromFoodItem(item)).toList();
    await isar.writeTxn(() async {
      await isar.foodItemSchemas.putAll(foodItems);
    });
  }

  Future<List<FoodItem>> getFoodItems() async {
    final isar = await db;
    final foodItems = await isar.foodItemSchemas.where().findAll();
    return foodItems.map((item) => item.toFoodItem()).toList();
  }
}
