import 'dart:convert';

/// title : "abc"
/// description : "abc abc abc abc"
/// date : "abc abc"
/// hid : "abcabcabc"

HolidayModel holidayModelFromJson(String str) =>
    HolidayModel.fromJson(json.decode(str));

String holidayModelToJson(HolidayModel data) => json.encode(data.toJson());

class HolidayModel {
  HolidayModel({
    String? title,
    String? description,
    String? date,
    String? hid,
  }) {
    _title = title;
    _description = description;
    _date = date;
    _hid = hid;
  }

  HolidayModel.fromJson(dynamic json) {
    _title = json['title'];
    _description = json['description'];
    _date = json['date'];
    _hid = json['hid'];
  }

  String? _title;
  String? _description;
  String? _date;
  String? _hid;

  HolidayModel copyWith({
    String? title,
    String? description,
    String? date,
    String? hid,
  }) =>
      HolidayModel(
        title: title ?? _title,
        description: description ?? _description,
        date: date ?? _date,
        hid: hid ?? _hid,
      );

  String? get title => _title;

  String? get description => _description;

  String? get date => _date;

  String? get hid => _hid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['hid'] = _hid;
    return map;
  }
}
