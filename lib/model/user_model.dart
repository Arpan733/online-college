import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    String? name,
    String? phoneNumber,
    String? email,
    String? adhar,
    String? dateOfBirth,
    String? qualification,
    String? address,
    String? photoUrl,
    String? uid,
  }) {
    _name = name;
    _phoneNumber = phoneNumber;
    _email = email;
    _adhar = adhar;
    _dateOfBirth = dateOfBirth;
    _qualification = qualification;
    _address = address;
    _photoUrl = photoUrl;
    _uid = uid;
  }

  UserModel.fromJson(dynamic json) {
    _name = json['name'];
    _phoneNumber = json['phoneNumber'];
    _email = json['email'];
    _adhar = json['adhar'];
    _dateOfBirth = json['dateOfBirth'];
    _qualification = json['qualification'];
    _address = json['address'];
    _photoUrl = json['photoUrl'];
    _uid = json['uid'];
  }

  String? _name;
  String? _phoneNumber;
  String? _email;
  String? _adhar;
  String? _dateOfBirth;
  String? _qualification;
  String? _address;
  String? _photoUrl;
  String? _uid;

  UserModel copyWith({
    String? name,
    String? phoneNumber,
    String? email,
    String? adhar,
    String? dateOfBirth,
    String? qualification,
    String? address,
    String? photoUrl,
    String? uid,
  }) =>
      UserModel(
        name: name ?? _name,
        phoneNumber: phoneNumber ?? _phoneNumber,
        email: email ?? _email,
        adhar: adhar ?? _adhar,
        dateOfBirth: dateOfBirth ?? _dateOfBirth,
        qualification: qualification ?? _qualification,
        address: address ?? _address,
        photoUrl: photoUrl ?? _photoUrl,
        uid: uid ?? _uid,
      );

  String? get name => _name;

  String? get phoneNumber => _phoneNumber;

  String? get email => _email;

  String? get adhar => _adhar;

  String? get dateOfBirth => _dateOfBirth;

  String? get qualification => _qualification;

  String? get address => _address;

  String? get photoUrl => _photoUrl;

  String? get uid => _uid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['phoneNumber'] = _phoneNumber;
    map['email'] = _email;
    map['adhar'] = _adhar;
    map['dateOfBirth'] = _dateOfBirth;
    map['qualification'] = _qualification;
    map['address'] = _address;
    map['photoUrl'] = _photoUrl;
    map['uid'] = _uid;
    return map;
  }
}
