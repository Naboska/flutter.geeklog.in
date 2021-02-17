import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geeklogin/constants/theme.dart';
import 'package:geeklogin/services/news_items_service.dart';
import 'package:geeklogin/screens/news_item.dart';

class NewsScreenWidget extends ConsumerWidget {
  // ignore: top_level_function_literal_block
  final _fetchItems = FutureProvider((ref) async {
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
        title: Image(image: AssetImage('assets/logo.png')),
      ),
      body: items.when(
          data: (news) => ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NewsItemScreenWidget(
                                    id: news[index].id,
                                    title: news[index].title.rendered)));
                          },
                          child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration:
                                  BoxDecoration(color: NewsBackgroundColor),
                              child: Column(children: [
                                Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Text(news[index].title.rendered,
                                        style: TextStyle(
                                            color: NewsTitleColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))),
                                Text(news[index].excerpt.rendered,
                                    style: TextStyle(color: NewsTextColor))
                              ])),
                        ),
                      ));
                },
                itemCount: news.length,
              ),
          loading: () => Image(
              image: AssetImage('assets/news_first_load.png'),
              fit: BoxFit.fill),
          error: (error, stack) => Center(child: Text('$error'))),
    );
  }
}
