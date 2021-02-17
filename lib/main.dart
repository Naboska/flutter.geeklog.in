import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geeklogin/screens/news.dart';
import 'package:geeklogin/constants/theme.dart';

void main() => runApp(ProviderScope(child: RootScreenWidget()));

class RootScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: PrimaryColor,
            scaffoldBackgroundColor: ScaffoldBackgroundColor
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Geeklogin'),
          ),
          body: NewsScreen(),
        ));
  }
}
