import 'dart:convert';

class StudentUserModel {
  String name;
  String phoneNumber;
  String email;
  String adhar;
  String dateOfBirth;
  String address;
  String photoUrl;
  String uid;
  String motherName;
  String fatherName;
  String year;
  String rollNo;
  String role;
  String id;
  String loginTime;
  String div;
  String notificationToken;

  StudentUserModel({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.adhar,
    required this.dateOfBirth,
    required this.address,
    required this.photoUrl,
    required this.uid,
    required this.motherName,
    required this.fatherName,
    required this.year,
    required this.rollNo,
    required this.role,
    required this.id,
    required this.loginTime,
    required this.div,
    required this.notificationToken,
  });

  factory StudentUserModel.fromRawJson(String str) => StudentUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentUserModel.fromJson(Map<String, dynamic> json) => StudentUserModel(
        name: json["name"] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
        email: json["email"] ?? "",
        adhar: json["adhar"] ?? "",
        dateOfBirth: json["dateOfBirth"] ?? "",
        address: json["address"] ?? "",
        photoUrl: json["photoUrl"] ?? "",
        uid: json["uid"] ?? "",
        motherName: json["motherName"] ?? "",
        fatherName: json["fatherName"] ?? "",
        year: json["year"] ?? "",
        rollNo: json["rollNo"] ?? "",
        role: json["role"] ?? "",
        id: json["id"] ?? "",
        loginTime: json["loginTime"] ?? "",
        div: json["div"] ?? "",
        notificationToken: json["notificationToken"] ?? "",
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
        "loginTime": loginTime,
        "div": div,
        "notificationToken": notificationToken,
      };
}
