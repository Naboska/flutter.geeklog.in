import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geeklogin/constants/theme.dart';
import 'package:geeklogin/store/navigate.dart';

class NavigateWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    final navigateIndex = watch(navigateState).state.index ?? 0;

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Новости',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Гайды',
        ),
      ],
      currentIndex: navigateIndex,
      selectedItemColor: WhiteColor,
      backgroundColor: PrimaryColor,
      onTap: (int index) {
        if (index != navigateIndex)
          context.read(navigateState).state = Navigate(index: index);
      },
    );
  }
}
