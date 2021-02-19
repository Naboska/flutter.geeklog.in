import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:geeklogin/models/news_item.dart';
import 'package:geeklogin/constants/api.dart';

class NewsService {
  Future<List<NewsItem>> fetchNews() async {
    final response = await http.get('$PUBLIC_API_URL/posts?categories=5');

    switch (response.statusCode) {
      case 200:
        var result = json.decode(response.body) as List<dynamic>;
        var newsItems = result.map((model) => NewsItem.fromJson(model));

        return newsItems.toList();
      case 404:
        throw Exception('Ошибка получения 404');
      default:
        throw Exception('Ошибка получения.');
    }
  }
}
