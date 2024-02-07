import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? preferences;

  init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static String get phoneNumber => UserSharedPreferences().get('phoneNumber');

  static String get name => UserSharedPreferences().get('name');

  static String get address => UserSharedPreferences().get('address');

  static String get dateOfBirth => UserSharedPreferences().get('dateOfBirth');

  static String get adhar => UserSharedPreferences().get('adhar');

  static String get qualification => UserSharedPreferences().get('qualification');

  static String get email => UserSharedPreferences().get('email');

  static String get uid => UserSharedPreferences().get('uid');

  static String get photoUrl => UserSharedPreferences().get('photoUrl');

  static String get role => UserSharedPreferences().get('role');

  static String get id => UserSharedPreferences().get('id');

  static String get year => UserSharedPreferences().get('year');

  static String get motherName => UserSharedPreferences().get('motherName');

  static String get fatherName => UserSharedPreferences().get('role');

  static Future setString({required String title, required String data}) async {
    await preferences?.setString(title, data);
  }

  String get(String title) {
    String data = preferences?.getString(title) ?? "";

    return data;
  }
}
