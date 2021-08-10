import 'dart:convert';

import 'package:http/http.dart' as http;

const ReadUrl = 'http://www.nkrtest.xyz/public/api/product';

class ProductFeed {
  int id;
  String name;
  String category;
  String price;
  String url;
  String isdelete;

  ProductFeed({
    required this.id,
    required this.url,
    required this.category,
    required this.isdelete,
    required this.name,
    required this.price,
  });

  factory ProductFeed.fromJson(Map<String, dynamic> json) {
    return ProductFeed(
      id: json['id'] as int,
      url: json['Pimage'] as String,
      category: json['Pcategory'] as String,
      name: json['Pname'] as String,
      price: json['Pprice'] as String,
      isdelete: json['is_delete'] as String,
    );
  }
}

class BackEndServiceProducts {
  List<ProductFeed> newsFromJson(String jsonString) {
    final data = json.decode(jsonString);

    List<ProductFeed> list = [];
    try {
      for (int i = 0; i < 20; i++) {
        ProductFeed _productFeed = ProductFeed(
          id: data['products'][i]['id'],
          url: data['products'][i]['Pimage'],
          category: data['products'][i]['Pcategory'],
          name: data['products'][i]['Pname'],
          price: data['products'][i]['Pprice'],
          isdelete: data['products'][i]['is_delete'],
        );
        list.add(_productFeed);
      }
    } catch (e) {
      return list;
    }
    return list;
  }

  Future<List<ProductFeed>> getProducts() async {
    final response = await http.get(Uri.parse(ReadUrl));
    if (response.statusCode == 200) {
      List<ProductFeed> list = newsFromJson(response.body);
      return list;
    } else {
      List<ProductFeed> list = [];
      return list;
    }
  }
}
