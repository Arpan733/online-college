import 'package:shared_preferences/shared_preferences.dart';

class TeacherSharedPreferences {
  static SharedPreferences? preferences;

  init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static String get phoneNumber =>
      TeacherSharedPreferences().get('phoneNumber');
  static String get name => TeacherSharedPreferences().get('name');
  static String get address => TeacherSharedPreferences().get('address');
  static String get dateOfBirth =>
      TeacherSharedPreferences().get('dateOfBirth');
  static String get adhar => TeacherSharedPreferences().get('adhar');
  static String get qualification =>
      TeacherSharedPreferences().get('qualification');
  static String get email => TeacherSharedPreferences().get('email');
  static String get uid => TeacherSharedPreferences().get('uid');
  static String get photoUrl => TeacherSharedPreferences().get('photoUrl');

  static setString({required String title, required String data}) async {
    await preferences?.setString(title, data);
  }

  String get(String title) {
    String data = preferences?.getString(title) ?? "";

    return data;
  }
}
