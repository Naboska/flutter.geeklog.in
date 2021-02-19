import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:geeklogin/constants/api.dart';
import 'package:geeklogin/models/monitoring.dart';

const int SERVER_ID = 208;

class MonitoringService {
  Future<Monitoring> fetchInfo() async {
    final response = await http.get('$PUBLIC_MONITORING_API/$SERVER_ID');
    switch (response.statusCode) {
      case 200:
        var result = json.decode(response.body);
        return Monitoring.fromJson(result);
      case 404:
        throw Exception('Ошибка получения 404');
      default:
        throw Exception('Ошибка получения.');
    }
  }
}
