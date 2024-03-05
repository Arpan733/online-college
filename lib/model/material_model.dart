import 'dart:convert';

class MaterialModel {
  String createdTime;
  String mid;
  String title;
  List<String> year;
  List<Materialss> materials;

  MaterialModel({
    required this.createdTime,
    required this.mid,
    required this.title,
    required this.year,
    required this.materials,
  });

  factory MaterialModel.fromRawJson(String str) => MaterialModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MaterialModel.fromJson(Map<String, dynamic> json) => MaterialModel(
        createdTime: json["createdTime"],
        mid: json["mid"],
        title: json["title"],
        year: List<String>.from(json["year"].map((x) => x)),
        materials: List<Materialss>.from(json["materials"].map((x) => Materialss.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "createdTime": createdTime,
        "mid": mid,
        "title": title,
        "year": List<dynamic>.from(year.map((x) => x)),
        "materials": List<dynamic>.from(materials.map((x) => x.toJson())),
      };
}

class Materialss {
  String name;
  String extension;
  String url;

  Materialss({
    required this.name,
    required this.extension,
    required this.url,
  });

  factory Materialss.fromRawJson(String str) => Materialss.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Materialss.fromJson(Map<String, dynamic> json) => Materialss(
        name: json["name"],
        extension: json["extension"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "extension": extension,
        "url": url,
      };
}
