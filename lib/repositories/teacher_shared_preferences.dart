import 'package:shared_preferences/shared_preferences.dart';

class TeacherSharedPreferences {
  SharedPreferences? preferences;

  init() async {
    preferences = await SharedPreferences.getInstance();
  }

  set(String title, String data) async {
    await preferences?.setString(title, data);
  }

  String? get(String title) {
    String? data = preferences?.getString(title);

    return data;
  }
}
