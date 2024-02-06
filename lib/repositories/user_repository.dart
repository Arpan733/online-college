import 'package:online_college/repositories/user_shared_preferences.dart';

class UserRepository {
  static saveUserPref(
      {String? adhar,
      String? email,
      String? dateOfBirth,
      String? qualification,
      String? year,
      String? id,
      String? motherName,
      String? fatherName,
      String? address,
      String? photoUrl,
      String? name,
      String? phoneNumber,
      String? uid}) {
    if (adhar != null) {
      UserSharedPreferences.setString(title: 'adhar', data: adhar);
    }
    if (email != null) {
      UserSharedPreferences.setString(title: 'email', data: email);
    }
    if (dateOfBirth != null) {
      UserSharedPreferences.setString(title: 'dateOfBirth', data: dateOfBirth);
    }
    if (qualification != null) {
      UserSharedPreferences.setString(title: 'qualification', data: qualification);
    }
    if (address != null) {
      UserSharedPreferences.setString(title: 'address', data: address);
    }
    if (photoUrl != null) {
      UserSharedPreferences.setString(title: 'photoUrl', data: photoUrl.toString());
    }
    if (name != null) {
      UserSharedPreferences.setString(title: 'name', data: name);
    }
    if (phoneNumber != null) {
      UserSharedPreferences.setString(title: 'phoneNumber', data: phoneNumber);
    }
    if (uid != null) {
      UserSharedPreferences.setString(title: 'uid', data: uid);
    }
    if (id != null) {
      UserSharedPreferences.setString(title: 'id', data: id);
    }
    if (year != null) {
      UserSharedPreferences.setString(title: 'year', data: year);
    }
    if (motherName != null) {
      UserSharedPreferences.setString(title: 'motherName', data: motherName);
    }
    if (fatherName != null) {
      UserSharedPreferences.setString(title: 'fatherName', data: fatherName);
    }
  }
}
