import 'package:online_college/consts/user_shared_preferences.dart';

class UserRepository {
  static Future saveUserPref(
      {String? adhar,
      String? email,
      String? dateOfBirth,
      String? qualification,
      String? year,
      String? id,
      String? motherName,
      String? fatherName,
      String? rollNo,
      String? address,
      String? photoUrl,
      String? name,
      String? phoneNumber,
      String? role,
      String? uid}) async {
    if (adhar != null) {
      await UserSharedPreferences.setString(title: 'adhar', data: adhar);
    }
    if (email != null) {
      await UserSharedPreferences.setString(title: 'email', data: email);
    }
    if (dateOfBirth != null) {
      await UserSharedPreferences.setString(title: 'dateOfBirth', data: dateOfBirth);
    }
    if (qualification != null) {
      await UserSharedPreferences.setString(title: 'qualification', data: qualification);
    }
    if (address != null) {
      await UserSharedPreferences.setString(title: 'address', data: address);
    }
    if (photoUrl != null) {
      await UserSharedPreferences.setString(title: 'photoUrl', data: photoUrl);
    }
    if (name != null) {
      await UserSharedPreferences.setString(title: 'name', data: name);
    }
    if (phoneNumber != null) {
      await UserSharedPreferences.setString(title: 'phoneNumber', data: phoneNumber);
    }
    if (uid != null) {
      await UserSharedPreferences.setString(title: 'uid', data: uid);
    }
    if (id != null) {
      await UserSharedPreferences.setString(title: 'id', data: id);
    }
    if (year != null) {
      await UserSharedPreferences.setString(title: 'year', data: year);
    }
    if (motherName != null) {
      await UserSharedPreferences.setString(title: 'motherName', data: motherName);
    }
    if (fatherName != null) {
      await UserSharedPreferences.setString(title: 'fatherName', data: fatherName);
    }
    if (role != null) {
      await UserSharedPreferences.setString(title: 'role', data: role);
    }
    if (rollNo != null) {
      await UserSharedPreferences.setString(title: 'rollNo', data: rollNo);
    }
  }
}
