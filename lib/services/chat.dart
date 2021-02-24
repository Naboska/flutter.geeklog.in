import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:geeklogin/models/chat.dart';
import 'package:geeklogin/constants/api.dart';

Chat parseChatMessage(String message) {
  final result = json.decode(message);

  return Chat.fromJson(result);
}

Future<String> sendChatPost({String message, String userName}) async {
  final response = await http.post('$PUBLIC_SERVER_URL/message',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: jsonEncode(<String, String>{
      'message': message,
      'userName': userName,
    }),
  );

  return response.body;
}


Future<List<Chat>> fetchChat() async {
  final response = await http.get('$PUBLIC_SERVER_URL/messages');

  switch (response.statusCode) {
    case 200:
      var result = json.decode(response.body) as List<dynamic>;
      var newsItems = result.map((model) => Chat.fromJson(model));

      return newsItems.toList();
    case 404:
      throw Exception('Ошибка получения 404');
    default:
      throw Exception('Ошибка получения.');
  }
}
