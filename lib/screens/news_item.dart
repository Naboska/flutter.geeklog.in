import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:geeklogin/services/news_items_service.dart';

class NewsItemScreenWidget extends StatelessWidget {
  final int id;
  final String title;

  final newsService = NewsService();

  NewsItemScreenWidget({@required this.id, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('$title')), body: Text(''));
  }
}
