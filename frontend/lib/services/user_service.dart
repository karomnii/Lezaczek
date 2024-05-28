import 'package:frontend/models/user.dart';
import 'package:frontend/api/user_api.dart';

class UserService {
  static final _api = UserApi();
  static Future<dynamic> login(LoginFormData data) async {
    return _api.login(data);
  }
}