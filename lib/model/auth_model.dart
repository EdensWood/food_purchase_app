import 'package:hive/hive.dart';

part 'auth_model.g.dart';

@HiveType(typeId: 0)
class AuthModel extends HiveObject {
  @HiveField(0)
  final String token;

  @HiveField(1)
  final String userId;

  AuthModel({required this.token, required this.userId});
}
