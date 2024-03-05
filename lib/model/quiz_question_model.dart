import 'dart:convert';

class QuizQuestionModel {
  String qqid;
  String question;
  List<Option> options;

  QuizQuestionModel({
    required this.qqid,
    required this.question,
    required this.options,
  });

  factory QuizQuestionModel.fromRawJson(String str) => QuizQuestionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) => QuizQuestionModel(
    qqid: json["qqid"],
    question: json["question"],
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "qqid": qqid,
    "question": question,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

class Option {
  String option;
  String isAnswer;

  Option({
    required this.option,
    required this.isAnswer,
  });

  factory Option.fromRawJson(String str) => Option.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    option: json["option"],
    isAnswer: json["isAnswer"],
  );

  Map<String, dynamic> toJson() => {
    "option": option,
    "isAnswer": isAnswer,
  };
}
