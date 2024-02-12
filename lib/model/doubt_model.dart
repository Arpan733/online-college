import 'dart:convert';

class DoubtModel {
  String year;
  String did;
  String createdTime;
  String title;
  String subject;
  List<Chat> chat;

  DoubtModel({
    required this.year,
    required this.did,
    required this.createdTime,
    required this.title,
    required this.subject,
    required this.chat,
  });

  factory DoubtModel.fromRawJson(String str) => DoubtModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DoubtModel.fromJson(Map<String, dynamic> json) => DoubtModel(
        year: json["year"],
        did: json["did"],
        createdTime: json["createdTime"],
        title: json["title"],
        subject: json["subject"],
        chat: List<Chat>.from(json["chat"].map((x) => Chat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "did": did,
        "createdTime": createdTime,
        "title": title,
        "subject": subject,
        "chat": List<dynamic>.from(chat.map((x) => x.toJson())),
      };
}

class Chat {
  String message;
  String time;
  String id;
  String role;

  Chat({
    required this.message,
    required this.time,
    required this.id,
    required this.role,
  });

  factory Chat.fromRawJson(String str) => Chat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        message: json["message"],
        time: json["time"],
        id: json["id"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "time": time,
        "id": id,
        "role": role,
      };
}
