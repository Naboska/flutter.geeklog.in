import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geeklogin/models/news_item.dart';

final newsSelectedState = StateProvider((ref) => NewsItem());