import 'dart:convert';

List<NewsModel> newsModelFromJson(String str) => List<NewsModel>.from(json.decode(str).map((x) => NewsModel.fromJson(x)));

class NewsModel {
  String id;
  String title;
  String fullnews;
  String images;
  String views;

  NewsModel({
    required this.id,
    required this.title,
    required this.fullnews,
    required this.images,
    required this.views,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    id: json["id"],
    title: json["title"],
    fullnews: json["fullnews"],
    images: json["images"],
    views: json["views"],
  );

}
