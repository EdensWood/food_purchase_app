import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'food_item.freezed.dart';
part 'food_item.g.dart';

@freezed
class FoodItem with _$FoodItem {
  @JsonSerializable(explicitToJson: true)
  const factory FoodItem({
    required int id,
    required String title,
    required String image,
    @Default(1) int quantity, //Default quantity set to 1
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) => _$FoodItemFromJson(json);
}

@collection
class FoodItemSchema {
  Id? id;

  late String title;
  late String image;

  FoodItemSchema();

  factory FoodItemSchema.fromFoodItem(FoodItem item) {
    return FoodItemSchema()
      ..id = item.id
      ..title = item.title
      ..image = item.image;
  }

  FoodItem toFoodItem() {
    return FoodItem(
      id: id!,
      title: title,
      image: image,
    );
  }
}
