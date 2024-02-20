import 'dart:convert';

class TimeTableModel {
  String year;
  Timetable timetable;

  TimeTableModel({
    required this.year,
    required this.timetable,
  });

  factory TimeTableModel.fromRawJson(String str) => TimeTableModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TimeTableModel.fromJson(Map<String, dynamic> json) => TimeTableModel(
        year: json["year"],
        timetable: Timetable.fromJson(json["timetable"]),
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "timetable": timetable.toJson(),
      };
}

class Timetable {
  List<Clas> mon;
  List<Clas> tue;
  List<Clas> wed;
  List<Clas> thu;
  List<Clas> fri;

  Timetable({
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
  });

  factory Timetable.fromRawJson(String str) => Timetable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Timetable.fromJson(Map<String, dynamic> json) => Timetable(
        mon: List<Clas>.from(json["Mon"].map((x) => x)),
        tue: List<Clas>.from(json["Tue"].map((x) => x)),
        wed: List<Clas>.from(json["Wed"].map((x) => x)),
        thu: List<Clas>.from(json["Thu"].map((x) => x)),
        fri: List<Clas>.from(json["Fri"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Mon": List<Clas>.from(mon.map((x) => x)),
        "Tue": List<Clas>.from(tue.map((x) => x)),
        "Wed": List<Clas>.from(wed.map((x) => x)),
        "Thu": List<Clas>.from(thu.map((x) => x)),
        "Fri": List<Clas>.from(fri.map((x) => x)),
      };
}

class Clas {
  String subject;
  String time;

  Clas({
    required this.subject,
    required this.time,
  });

  factory Clas.fromRawJson(String str) => Clas.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Clas.fromJson(Map<String, dynamic> json) => Clas(
        subject: json["subject"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "time": time,
      };
}
