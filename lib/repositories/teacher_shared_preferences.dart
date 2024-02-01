import 'package:shared_preferences/shared_preferences.dart';

class TeacherSharedPreferences {
  SharedPreferences? preferences;

  init () async {
  preferences = await SharedPreferences.getInstance()
}
}