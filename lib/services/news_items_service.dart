import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:geeklogin/models/news_item.dart';
import 'package:geeklogin/constants/api.dart';

List<NewsItem> parseNewsItems(String responseBody) {
  var result = json.decode(responseBody) as List<dynamic>;
  var newsItems = result.map((model) => NewsItem.fromJson(model));

  return newsItems.toList();
}

Future<List<NewsItem>> newsItemsService() async {
  final response = await http.get('$PUBLIC_API_URL/posts');

  switch(response.statusCode) {
    case 200: return compute(parseNewsItems, response.body);
    case 404: throw Exception('Ошибка получения 404');
    default: throw Exception('Ошибка получения.');
  }
}
