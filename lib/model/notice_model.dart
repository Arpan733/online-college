import 'dart:convert';

class NoticeModel {
  String createdTime;
  String nid;
  String title;
  List<String> year;
  String description;
  String photoUrl;

  NoticeModel({
    required this.createdTime,
    required this.nid,
    required this.title,
    required this.year,
    required this.description,
    required this.photoUrl,
  });

  factory NoticeModel.fromRawJson(String str) => NoticeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
        createdTime: json["createdTime"],
        nid: json["nid"],
        title: json["title"],
        year: List<String>.from(json["year"].map((x) => x)),
        description: json["description"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "createdTime": createdTime,
        "nid": nid,
        "title": title,
        "year": List<dynamic>.from(year.map((x) => x)),
        "description": description,
        "photoUrl": photoUrl,
      };
}
