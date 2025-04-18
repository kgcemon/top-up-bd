import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/UserModel.dart';


class AuthController {
  static String? accessToken;
  static UserData? userData;

  static Future<void> saveUserData(UserData userData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('userData', jsonEncode(userData.toJson()));
    AuthController.userData = userData;
  }

  static Future<UserData?> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? result = sharedPreferences.getString('userData');
    if (result == null) {
      return null;
    }
    final user =  UserData.fromJson(jsonDecode(result));
    AuthController.userData = user;
    return user;
  }

  static Future<void> saveUserToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('jwtToken', token);
    accessToken = token;
  }

  static Future<String?> getUserToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('jwtToken');
  }

  static Future<bool> isUserLoggedIn() async {
    final result = await getUserToken();
    accessToken = result;
    bool loginState = result != null;
    if (loginState) {
      await getUserData();
    }
    return loginState;
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}