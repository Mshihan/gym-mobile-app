import 'dart:convert';

import 'package:http/http.dart' as http;

const ReadUrl = 'http://www.nkrtest.xyz/public/api/home';

class NewsFeed {
  String heading;
  String description;
  int id;
  String imageUrl;
  String by;
  String date;
  String delete;

  NewsFeed({
    required this.heading,
    required this.description,
    required this.id,
    required this.imageUrl,
    required this.by,
    required this.date,
    required this.delete,
  });

  factory NewsFeed.fromJson(Map<String, dynamic> json) {
    return NewsFeed(
      id: json['id'] as int,
      heading: json['Nheading'] as String,
      description: json['Ndiscription'] as String,
      imageUrl: json['Nimage'] as String,
      by: json['Ninfor1'] as String,
      date: json['Ninfor2'] as String,
      delete: json['is_delete'] as String,
    );
  }
}

class BackEndServiceNews {
  List<NewsFeed> newsFromJson(String jsonString) {
    final data = json.decode(jsonString);

    List<NewsFeed> list = [];
    try {
      for (int i = 0; i < 10; i++) {
        NewsFeed _newsFeed = NewsFeed(
          id: data['all_news'][i]['id'],
          heading: data['all_news'][i]['Nheading'],
          description: data['all_news'][i]['Ndiscription'],
          imageUrl: data['all_news'][i]['Nimage'],
          by: data['all_news'][i]['Ninfor1'],
          date: data['all_news'][i]['Ninfor2'],
          delete: data['all_news'][i]['is_delete'],
        );
        list.add(_newsFeed);
      }
    } catch (e) {
      return list;
    }
    return list;
  }

  Future<List<NewsFeed>> getNews() async {
    final response = await http.get(Uri.parse(ReadUrl));
    if (response.statusCode == 200) {
      List<NewsFeed> list = newsFromJson(response.body);
      return list;
    } else {
      List<NewsFeed> list = [];
      return list;
    }
  }
}
