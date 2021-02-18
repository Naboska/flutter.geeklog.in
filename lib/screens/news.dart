import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' show parseFragment;

import 'package:geeklogin/constants/theme.dart';
import 'package:geeklogin/models/news_item.dart';
import 'package:geeklogin/services/news_items.dart';
import 'package:geeklogin/screens/news_item.dart';
import 'package:geeklogin/store/news.dart';

class NewsScreenWidget extends ConsumerWidget {
  final _fetchItems = FutureProvider<List<NewsItem>>((ref) async {
    final NewsService newsService = NewsService();

    var result = await newsService.fetchNews();
    return result;
  });

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    var items = watch(_fetchItems);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image(image: AssetImage('assets/logo.png'))),
      ),
      body: items.when(
          data: (news) => ListView.builder(
                itemBuilder: (context, index) {
                  final String title =
                      parseFragment(news[index].title.rendered).text;
                  final String content =
                      parseFragment(news[index].excerpt.rendered).text;

                  return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            context.read(newsSelectedState).state = news[index];

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NewsItemScreenWidget()));
                          },
                          child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration:
                                  BoxDecoration(color: NewsBackgroundColor),
                              child: Column(children: [
                                Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Text(title,
                                        style: TextStyle(
                                            color: NewsTitleColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))),
                                Text(content,
                                    style: TextStyle(color: NewsTextColor))
                              ])),
                        ),
                      ));
                },
                itemCount: news.length,
              ),
          loading: () => Container(
              constraints: BoxConstraints.expand(),
              child: Image(
                  image: AssetImage('assets/news_first_load.png'),
                  fit: BoxFit.fill)),
          error: (error, stack) => Center(child: Text('$error'))),
    );
  }
}
