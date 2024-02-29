import 'dart:convert';

class MaterialModel {
  String mid;
  String title;
  List<String> year;
  List<Material> materials;

  MaterialModel({
    required this.mid,
    required this.title,
    required this.year,
    required this.materials,
  });

  factory MaterialModel.fromRawJson(String str) => MaterialModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MaterialModel.fromJson(Map<String, dynamic> json) => MaterialModel(
        mid: json["mid"],
        title: json["title"],
        year: List<String>.from(json["year"].map((x) => x)),
        materials: List<Material>.from(json["materials"].map((x) => Material.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "title": title,
        "year": List<dynamic>.from(year.map((x) => x)),
        "materials": List<dynamic>.from(materials.map((x) => x.toJson())),
      };
}

class Material {
  String name;
  String extension;
  String url;

  Material({
    required this.name,
    required this.extension,
    required this.url,
  });

  factory Material.fromRawJson(String str) => Material.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Material.fromJson(Map<String, dynamic> json) => Material(
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
