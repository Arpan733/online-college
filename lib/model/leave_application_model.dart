import 'dart:convert';

class LeaveApplicationModel {
  String title;
  String lid;
  String description;
  String startDate;
  String endDate;
  String status;
  String sid;

  LeaveApplicationModel({
    required this.title,
    required this.lid,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.sid,
  });

  factory LeaveApplicationModel.fromRawJson(String str) =>
      LeaveApplicationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeaveApplicationModel.fromJson(Map<String, dynamic> json) => LeaveApplicationModel(
        title: json["title"],
        lid: json["lid"],
        description: json["description"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        status: json["status"],
        sid: json["sid"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "lid": lid,
        "description": description,
        "startDate": startDate,
        "endDate": endDate,
        "status": status,
        "sid": sid,
      };
}
