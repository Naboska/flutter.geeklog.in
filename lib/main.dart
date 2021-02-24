import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geeklogin/constants/theme.dart';
import 'package:geeklogin/widgets/navigate.dart';
import 'package:geeklogin/widgets/router.dart';


void main() => runApp(ProviderScope(child: RootScreenWidget()));

class RootScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: PrimaryColor,
            accentColor: PrimaryColor,
            scaffoldBackgroundColor: ScaffoldBackgroundColor),
        home: Scaffold(
          body: RouterWidget(),
          bottomNavigationBar: NavigateWidget(),
        ));
  }
}
