import 'dart:convert';

class ResultModel {
  String? cpi;
  String? sid;
  List<Result>? result;

  ResultModel({
    this.cpi,
    this.sid,
    this.result,
  });

  factory ResultModel.fromRawJson(String str) => ResultModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
        cpi: json["cpi"],
        sid: json["sid"],
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cpi": cpi,
        "sid": sid,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  String? year;
  String? spi;
  List<Datum>? data;

  Result({
    this.year,
    this.spi,
    this.data,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        year: json["year"],
        spi: json["spi"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "spi": spi,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? subject;
  String? marks;

  Datum({
    this.subject,
    this.marks,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        subject: json["subject"],
        marks: json["marks"],
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "marks": marks,
      };
}
