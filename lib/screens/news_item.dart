import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geeklogin/constants/theme.dart';
import 'package:geeklogin/models/news_item.dart';
import 'package:geeklogin/services/news_items_service.dart';
import 'package:geeklogin/store/news.dart';

class NewsItemScreenWidget extends ConsumerWidget {
  final _fetchItem = FutureProvider.family<NewsItem, int>((ref, id) async {
    final newsService = NewsService();

    var response = await newsService.fetchNewsItem(id);
    return response;
  });

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    var newsItem = context.read(newsSelectedState).state;
    var item = watch(_fetchItem(newsItem.id));

    return Scaffold(
        appBar: AppBar(title: Text(newsItem.title.rendered)),
        body: item.when(
            data: (news) => Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(news.content.rendered)),
            loading: () => Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(PrimaryColor))),
            error: (error, stack) => Center(child: Text('$error'))));
  }
}
