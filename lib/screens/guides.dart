import 'package:flutter/material.dart';

import 'package:geeklogin/constants/post.dart';
import 'package:geeklogin/widgets/posts.dart';

class GuidesScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PostsWidget(category: GUIDES_POST_CATEGORY);
  }
}
