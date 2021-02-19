import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:geeklogin/models/post.dart';
import 'package:geeklogin/constants/api.dart';

Future<List<Post>> fetchPosts({@required int page, @required int categories}) async {
  final response = await http.get('$PUBLIC_API_URL/posts?categories=$categories&page=$page');

  switch (response.statusCode) {
    case 200:
      var result = json.decode(response.body) as List<dynamic>;
      var newsItems = result.map((model) => Post.fromJson(model));

      return newsItems.toList();
    case 404:
      throw Exception('Ошибка получения 404');
    default:
      throw Exception('Ошибка получения.');
  }
}
