import 'dart:convert';

class SchoolGalleryModel {
  String url;
  String noOfLikes;
  List<String> likedList;
  String sgid;

  SchoolGalleryModel({
    required this.url,
    required this.noOfLikes,
    required this.likedList,
    required this.sgid,
  });

  factory SchoolGalleryModel.fromRawJson(String str) =>
      SchoolGalleryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SchoolGalleryModel.fromJson(Map<String, dynamic> json) => SchoolGalleryModel(
        url: json["url"],
        noOfLikes: json["noOfLikes"],
        likedList: List<String>.from(json["likedList"].map((x) => x)),
        sgid: json["sgid"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "noOfLikes": noOfLikes,
        "likedList": List<dynamic>.from(likedList.map((x) => x)),
        "sgid": sgid,
      };
}
