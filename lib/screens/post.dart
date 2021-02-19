import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' show parseFragment;

import 'package:geeklogin/store/post.dart';

class PostScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var newsItem = context.read(postState).state;

    final String title = parseFragment(newsItem.title.rendered).text;
    final newsBody = parseFragment(newsItem.content.rendered).children;

    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Padding(
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
                          child: Image.network(figure.attributes['src']));
                  }

                if (item.localName == 'img')
                  return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Image.network(item.attributes['src']));

                return Padding(padding: EdgeInsets.only(bottom: 12));
              },
              itemCount: newsBody.length),
        ));
  }
}
