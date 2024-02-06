import 'dart:convert';

class TeacherUserModel {
  String? name;
  String? phoneNumber;
  String? email;
  String? adhar;
  String? dateOfBirth;
  String? address;
  String? photoUrl;
  String? qualification;
  String? uid;
  String? role;
  String? id;

  TeacherUserModel({
    this.name,
    this.phoneNumber,
    this.email,
    this.adhar,
    this.dateOfBirth,
    this.address,
    this.photoUrl,
    this.qualification,
    this.uid,
    this.role,
    this.id,
  });

  factory TeacherUserModel.fromRawJson(String str) => TeacherUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TeacherUserModel.fromJson(Map<String, dynamic> json) => TeacherUserModel(
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        adhar: json["adhar"],
        dateOfBirth: json["dateOfBirth"],
        address: json["address"],
        photoUrl: json["photoUrl"],
        qualification: json["qualification"],
        uid: json["uid"],
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
        "qualification": qualification,
        "uid": uid,
        "role": role,
        "id": id,
      };
}
