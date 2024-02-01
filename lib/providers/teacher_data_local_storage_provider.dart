import 'package:flutter/cupertino.dart';

class TeacherDataLocalStorageProvider extends ChangeNotifier {
  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;

  String? _name;
  String? get name => _name;

  String? _address;
  String? get address => _address;

  String? _dateOfBirth;
  String? get dateOfBirth => _dateOfBirth;

  String? _aadhar;
  String? get aadhar => _aadhar;

  String? _degree;
  String? get degree => _degree;
}
