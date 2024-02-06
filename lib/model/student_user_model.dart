import 'dart:convert';

class StudentUserModel {
  String? name;
  String? phoneNumber;
  String? email;
  String? adhar;
  String? dateOfBirth;
  String? address;
  String? photoUrl;
  String? uid;
  String? motherName;
  String? fatherName;
  String? year;
  String? rollNo;
  String? role;
  String? id;

  StudentUserModel({
    this.name,
    this.phoneNumber,
    this.email,
    this.adhar,
    this.dateOfBirth,
    this.address,
    this.photoUrl,
    this.uid,
    this.motherName,
    this.fatherName,
    this.year,
    this.rollNo,
    this.role,
    this.id,
  });

  factory StudentUserModel.fromRawJson(String str) => StudentUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentUserModel.fromJson(Map<String, dynamic> json) => StudentUserModel(
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        adhar: json["adhar"],
        dateOfBirth: json["dateOfBirth"],
        address: json["address"],
        photoUrl: json["photoUrl"],
        uid: json["uid"],
        motherName: json["motherName"],
        fatherName: json["fatherName"],
        year: json["year"],
        rollNo: json["rollNo"],
        role: json["role"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "adhar": adhar,
        "dateOfBirth": dateOfBirth,
        "address": address,
        "photoUrl": photoUrl,
        "uid": uid,
        "motherName": motherName,
        "fatherName": fatherName,
        "year": year,
        "rollNo": rollNo,
        "role": role,
        "id": id,
      };
}
