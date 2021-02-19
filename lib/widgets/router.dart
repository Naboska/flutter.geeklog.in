import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geeklogin/screens/home.dart';
import 'package:geeklogin/screens/news.dart';
import 'package:geeklogin/store/navigate.dart';

class RouterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    int navigateIndex = watch(navigateState).state.index ?? 0;

    switch (navigateIndex) {
      case 1:
        return NewsScreenWidget();
      default:
        return HomeScreenWidget();
    }
  }
}