import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geeklogin/constants/post.dart';
import 'package:html/parser.dart' show parseFragment;

import 'package:geeklogin/constants/theme.dart';
import 'package:geeklogin/models/post.dart';
import 'package:geeklogin/services/post.dart';
import 'package:geeklogin/screens/post.dart';
import 'package:geeklogin/store/post.dart';

class PostsWidget extends StatefulWidget {
  final int category;
  PostsWidget({this.category});

  @override
  _PostsWidgetState createState() => _PostsWidgetState(category: category);
}

class _PostsWidgetState extends State<PostsWidget> {
  final int category;
  final int _limit = 10;
  final int _fetchThreshold = 3;

  bool _isLoading;
  bool _isEnd;
  int _page;
  List<Post> _news;

  _PostsWidgetState({this.category});

  Future<void> fetchNextNews() async {
    final int nextPage = _page + 1;

    try {
      final response = await fetchPosts(page: nextPage, categories: category);
      if (mounted) setState(() {
        _isEnd = response.length != _limit;
        _isLoading = false;
        _page = nextPage;
        _news.addAll(response);
      });
    } catch (e) {
      if (mounted) setState(() {
        _isEnd = true;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isEnd = false;
    _page = 0;
    _isLoading = true;
    _news = [];
    fetchNextNews();
  }

  Widget newsListWidget() {
    if (_isLoading && _news.length == 0)
      return Container(
          constraints: BoxConstraints.expand(),
          child: Center(child: CircularProgressIndicator()));

    if (_news.length > 0)
      return ListView.builder(
          itemCount: _news.length + (!_isEnd ? 1 : 0),
          itemBuilder: (context, index) {
            final int newsLength = _news.length;

            if (newsLength > 0 && index == newsLength - _fetchThreshold)
              fetchNextNews();

            if (index == _news.length && !_isEnd)
              return Container(
                  width: double.infinity,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Center(child: CircularProgressIndicator())));

            final String title =
                parseFragment(_news[index].title.rendered).text;
            final String content =
                parseFragment(_news[index].excerpt.rendered).text;

            return Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      context
                          .read(postState)
                          .state = _news[index];

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PostScreenWidget()));
                    },
                    child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(color: NewsBackgroundColor),
                        child: Column(children: [
                          Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(title,
                                  style: TextStyle(
                                      color: NewsTitleColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))),
                          Text(content, style: TextStyle(color: NewsTextColor))
                        ])),
                  ),
                ));
          });

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(category == NEWS_POST_CATEGORY ? 'Новости' : 'Гайды')),
        ),
        body: newsListWidget());
  }
}