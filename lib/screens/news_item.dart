import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' show parseFragment;

import 'package:geeklogin/constants/theme.dart';
import 'package:geeklogin/models/news_item.dart';
import 'package:geeklogin/services/news_items.dart';
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

    final String title = parseFragment(newsItem.title.rendered).text;
    final newsBody = parseFragment(newsItem.content.rendered).children;

    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: item.when(
            data: (news) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        final item = newsBody[index];

                        if (item.localName == 'p')
                          return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(item.text));

                        if (item.localName == 'figure')
                          for (var figure in item.children) {
                            if (figure.localName == 'img')
                              return Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child:
                                  Image.network(figure.attributes['src']));
                          }

                        if (item.localName == 'img')
                          return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Image.network(item.attributes['src']));

                        return Padding(padding: EdgeInsets.only(bottom: 12));
                      },
                      itemCount: newsBody.length),
                ),
            loading: () => Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(PrimaryColor))),
            error: (error, stack) => Center(child: Text('$error'))));
  }
}
