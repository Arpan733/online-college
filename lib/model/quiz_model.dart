import 'dart:convert';

class QuizModel {
  String qid;
  String sid;
  String createdDateTime;
  List<Question> questions;
  String takenTime;
  String right;
  String wrong;
  String skip;

  QuizModel({
    required this.qid,
    required this.sid,
    required this.createdDateTime,
    required this.questions,
    required this.takenTime,
    required this.right,
    required this.wrong,
    required this.skip,
  });

  factory QuizModel.fromRawJson(String str) => QuizModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        qid: json["qid"],
        sid: json["sid"],
        createdDateTime: json["createdDateTime"],
        questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
        takenTime: json["takenTime"],
        right: json["right"],
        wrong: json["wrong"],
        skip: json["skip"],
      );

  Map<String, dynamic> toJson() => {
        "qid": qid,
        "sid": sid,
        "createdDateTime": createdDateTime,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "takenTime": takenTime,
        "right": right,
        "wrong": wrong,
        "skip": skip,
      };
}

class Question {
  String qqid;
  String result;

  Question({
    required this.qqid,
    required this.result,
  });

  factory Question.fromRawJson(String str) => Question.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        qqid: json["qqid"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "qqid": qqid,
        "result": result,
      };
}
