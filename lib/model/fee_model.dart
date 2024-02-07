import 'dart:convert';

class FeeModel {
  String? fid;
  String? title;
  String? lastDate;
  String? createdDate;
  String? totalAmount;
  String? year;
  List<FeeDescription>? feeDescription;
  List<PaidStudent>? paidStudents;

  FeeModel({
    this.fid,
    this.title,
    this.lastDate,
    this.createdDate,
    this.totalAmount,
    this.year,
    this.feeDescription,
    this.paidStudents,
  });

  factory FeeModel.fromRawJson(String str) => FeeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeeModel.fromJson(Map<String, dynamic> json) => FeeModel(
        fid: json["fid"],
        title: json["title"],
        lastDate: json["lastDate"],
        createdDate: json["createdDate"],
        totalAmount: json["totalAmount"],
        year: json["year"],
        feeDescription: json["feeDescription"] == null
            ? []
            : List<FeeDescription>.from(
                json["feeDescription"]!.map((x) => FeeDescription.fromJson(x))),
        paidStudents: json["paidStudents"] == null
            ? []
            : List<PaidStudent>.from(json["paidStudents"]!.map((x) => PaidStudent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "fid": fid,
        "title": title,
        "lastDate": lastDate,
        "createdDate": createdDate,
        "totalAmount": totalAmount,
        "year": year,
        "feeDescription": feeDescription == null
            ? []
            : List<dynamic>.from(feeDescription!.map((x) => x.toJson())),
        "paidStudents":
            paidStudents == null ? [] : List<dynamic>.from(paidStudents!.map((x) => x.toJson())),
      };
}

class FeeDescription {
  String? title;
  String? amount;

  FeeDescription({
    this.title,
    this.amount,
  });

  factory FeeDescription.fromRawJson(String str) => FeeDescription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeeDescription.fromJson(Map<String, dynamic> json) => FeeDescription(
        title: json["title"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "amount": amount,
      };
}

class PaidStudent {
  String? sid;
  String? refNo;
  String? paidTime;

  PaidStudent({
    this.sid,
    this.refNo,
    this.paidTime,
  });

  factory PaidStudent.fromRawJson(String str) => PaidStudent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaidStudent.fromJson(Map<String, dynamic> json) => PaidStudent(
        sid: json["sid"],
        refNo: json["refNo"],
        paidTime: json["paidTime"],
      );

  Map<String, dynamic> toJson() => {
        "sid": sid,
        "refNo": refNo,
        "paidTime": paidTime,
      };
}
