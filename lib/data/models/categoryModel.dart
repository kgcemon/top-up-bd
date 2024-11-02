import 'dart:convert';

class CategoryModel {
  final int id;
  final String categoryName;
  final String categoryImage;
  final List<Amount> amountList;
  final String stock;
  final String inputName;
  final String? description;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.categoryImage,
    required this.amountList,
    required this.stock,
    required this.inputName,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    var amountListFromJson = json['amount_list'] as String;
    List<dynamic> amountListJson = [];
    if (amountListFromJson.isNotEmpty) {
      amountListJson = jsonDecode(amountListFromJson);
    }

    return CategoryModel(
      id: json['id'],
      categoryName: json['catagory_name'],
      categoryImage: json['catagory_image'],
      amountList: amountListJson.map((e) => Amount.fromJson(e)).toList(),
      stock: json['stock'],
      inputName: json['inputname'],
      description: json['description'],
    );
  }
}

class Amount {
  final String name;
  final String price;

  Amount({required this.name, required this.price});

  factory Amount.fromJson(Map<String, dynamic> json) {
    return Amount(
      name: json['name'],
      price: json['price'],
    );
  }
}
