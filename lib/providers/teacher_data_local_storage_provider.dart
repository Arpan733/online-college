import 'package:flutter/cupertino.dart';

import '../repositories/teacher_shared_preferences.dart';

class TeacherSharedPreferencesProvider extends ChangeNotifier {
  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;

  setPhoneNumber(String number) =>
      TeacherSharedPreferences().set('phoneNumber', number);

  String? _name;
  String? get name => _name;

  setName(String name) => TeacherSharedPreferences().set('name', name);

  String? _address;
  String? get address => _address;

  setAddress(String address) =>
      TeacherSharedPreferences().set('address', address);

  String? _dateOfBirth;
  String? get dateOfBirth => _dateOfBirth;

  setDateOfBirth(String dateOfBirth) =>
      TeacherSharedPreferences().set('dateOfBirth', dateOfBirth);

  String? _aadhar;
  String? get aadhar => _aadhar;

  setAadhar(String aadhar) => TeacherSharedPreferences().set('aadhar', aadhar);

  String? _degree;
  String? get degree => _degree;

  setDegree(String degree) => TeacherSharedPreferences().set('degree', degree);

  String? _uid;
  String? get uid => _uid;

  setUid(String uid) => TeacherSharedPreferences().set('uid', uid);

  getAllData() {
    _phoneNumber = TeacherSharedPreferences().get('phoneNumber');
    _name = TeacherSharedPreferences().get('name');
    _address = TeacherSharedPreferences().get('address');
    _dateOfBirth = TeacherSharedPreferences().get('dateOfBirth');
    _aadhar = TeacherSharedPreferences().get('aadhar');
    _degree = TeacherSharedPreferences().get('degree');
    _uid = TeacherSharedPreferences().get('uid');
  }
}
