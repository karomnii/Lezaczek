import 'package:frontend/models/user.dart';
import 'package:frontend/api/user_api.dart';

class UserService {
  static final _api = UserApi();
  static Future<dynamic> login(LoginFormData data) async {
    return _api.login(data);
  }
  static Future<dynamic> register(RegisterFormData data) async {
    return _api.register(data);
  }
  static Future<dynamic> deleteAccount(User user) async {
    return _api.deleteAccount(user);
  }
}