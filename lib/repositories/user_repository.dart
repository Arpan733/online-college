import 'package:online_college/repositories/teacher_shared_preferences.dart';

class UserRepository {
  static saveUserPref(
      {String? adhar,
      String? email,
      String? dateOfBirth,
      String? qualification,
      String? address,
      String? photoUrl,
      String? name,
      String? phoneNumber,
      String? uid}) {
    if (adhar != null) {
      TeacherSharedPreferences.setString(title: 'adhar', data: adhar);
    }
    if (email != null) {
      TeacherSharedPreferences.setString(title: 'email', data: email);
    }
    if (dateOfBirth != null) {
      TeacherSharedPreferences.setString(
          title: 'dateOfBirth', data: dateOfBirth);
    }
    if (qualification != null) {
      TeacherSharedPreferences.setString(
          title: 'qualification', data: qualification);
    }
    if (address != null) {
      TeacherSharedPreferences.setString(title: 'address', data: address);
    }
    if (photoUrl != null) {
      TeacherSharedPreferences.setString(
          title: 'photoUrl', data: photoUrl.toString());
    }
    if (name != null) {
      TeacherSharedPreferences.setString(title: 'name', data: name);
    }
    if (phoneNumber != null) {
      TeacherSharedPreferences.setString(
          title: 'phoneNumber', data: phoneNumber);
    }
    if (uid != null) {
      TeacherSharedPreferences.setString(title: 'uid', data: uid);
    }
  }
}
