import 'dart:convert';

class MeetingModel {
  String mid;
  String title;
  List<String> year;
  String time;
  String createdTime;
  String agoraToken;
  String channelName;

  MeetingModel({
    required this.mid,
    required this.title,
    required this.year,
    required this.time,
    required this.createdTime,
    required this.agoraToken,
    required this.channelName,
  });

  factory MeetingModel.fromRawJson(String str) => MeetingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MeetingModel.fromJson(Map<String, dynamic> json) => MeetingModel(
    mid: json["mid"],
    title: json["title"],
    year: List<String>.from(json["year"].map((x) => x)),
    time: json["time"],
    createdTime: json["createdTime"],
    agoraToken: json["agoraToken"],
    channelName: json["channelName"],
  );

  Map<String, dynamic> toJson() => {
    "mid": mid,
    "title": title,
    "year": List<dynamic>.from(year.map((x) => x)),
    "time": time,
    "createdTime": createdTime,
    "agoraToken": agoraToken,
    "channelName": channelName,
  };
}
