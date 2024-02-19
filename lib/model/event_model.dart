import 'dart:convert';

class EventModel {
  String eid;
  String title;
  String description;
  String url;
  String dateTime;

  EventModel({
    required this.eid,
    required this.title,
    required this.description,
    required this.url,
    required this.dateTime,
  });

  factory EventModel.fromRawJson(String str) => EventModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        eid: json["eid"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toJson() => {
        "eid": eid,
        "title": title,
        "description": description,
        "url": url,
        "dateTime": dateTime,
      };
}
