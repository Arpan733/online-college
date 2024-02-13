import 'dart:convert';

class AssignmentModel {
  String aid;
  String title;
  String createdDateTime;
  String lastDateTime;
  String subject;
  String year;
  List<Submitted> submitted;

  AssignmentModel({
    required this.aid,
    required this.title,
    required this.createdDateTime,
    required this.lastDateTime,
    required this.subject,
    required this.year,
    required this.submitted,
  });

  factory AssignmentModel.fromRawJson(String str) => AssignmentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssignmentModel.fromJson(Map<String, dynamic> json) => AssignmentModel(
        aid: json["aid"],
        title: json["title"],
        createdDateTime: json["createdDateTime"],
        lastDateTime: json["lastDateTime"],
        subject: json["subject"],
        year: json["year"],
        submitted: List<Submitted>.from(json["submitted"].map((x) => Submitted.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "title": title,
        "createdDateTime": createdDateTime,
        "lastDateTime": lastDateTime,
        "subject": subject,
        "year": year,
        "submitted": List<dynamic>.from(submitted.map((x) => x.toJson())),
      };
}

class Submitted {
  String sid;
  String url;
  String submitTime;

  Submitted({
    required this.sid,
    required this.url,
    required this.submitTime,
  });

  factory Submitted.fromRawJson(String str) => Submitted.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Submitted.fromJson(Map<String, dynamic> json) => Submitted(
        sid: json["sid"],
        url: json["url"],
        submitTime: json["submitTime"],
      );

  Map<String, dynamic> toJson() => {
        "sid": sid,
        "url": url,
        "submitTime": submitTime,
      };
}
