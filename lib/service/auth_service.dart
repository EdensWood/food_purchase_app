import 'package:hive/hive.dart';
import '../model/auth_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Box<AuthModel> _authBox = Hive.box('authBox');

  Future<void> saveAuthData(String token, String userId) async {
    final authData = AuthModel(token: token, userId: userId);
    await _authBox.put('authData', authData);
  }

  AuthModel? getAuthData() {
    return _authBox.get('authData');
  }

  Future<void> clearAuthData() async {
    await _authBox.delete('authData');
  }

  bool isAuthenticated() {
    return _authBox.containsKey('authData');
  }

  Future<void> registerUser(String username, String password) async {
    final userBox = Hive.box<String>('userBox');
    await userBox.put(username, password);
  }

  bool loginUser(String username, String password) {
    final userBox = Hive.box<String>('userBox');
    return userBox.get(username) == password;
  }
}
