import 'package:flutter/material.dart';

import 'package:geeklogin/constants/post.dart';
import 'package:geeklogin/widgets/posts.dart';

class NewsScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PostsWidget(category: NEWS_POST_CATEGORY);
  }
}
