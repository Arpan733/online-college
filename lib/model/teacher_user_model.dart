import 'dart:convert';

class TeacherUserModel {
  String name;
  String phoneNumber;
  String email;
  String adhar;
  String dateOfBirth;
  String address;
  String photoUrl;
  String qualification;
  String uid;
  String role;
  String id;
  String loginTime;
  List<String> subjects;
  String notificationToken;

  TeacherUserModel({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.adhar,
    required this.dateOfBirth,
    required this.address,
    required this.photoUrl,
    required this.qualification,
    required this.uid,
    required this.role,
    required this.id,
    required this.loginTime,
    required this.subjects,
    required this.notificationToken,
  });

  factory TeacherUserModel.fromRawJson(String str) => TeacherUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TeacherUserModel.fromJson(Map<String, dynamic> json) => TeacherUserModel(
        name: json["name"] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
        email: json["email"] ?? "",
        adhar: json["adhar"] ?? "",
        dateOfBirth: json["dateOfBirth"] ?? "",
        address: json["address"] ?? "",
        photoUrl: json["photoUrl"] ?? "",
        qualification: json["qualification"] ?? "",
        uid: json["uid"] ?? "",
        role: json["role"] ?? "",
        id: json["id"] ?? "",
        loginTime: json["loginTime"] ?? "",
        subjects: List<String>.from(json["subjects"].map((x) => x)),
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
        "qualification": qualification,
        "uid": uid,
        "role": role,
        "id": id,
        "loginTime": loginTime,
        "subjects": List<dynamic>.from(subjects.map((x) => x)),
        "notificationToken": notificationToken,
      };
}
