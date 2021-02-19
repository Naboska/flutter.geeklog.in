import 'package:flutter/material.dart';
import 'package:geeklogin/constants/theme.dart';

import 'package:geeklogin/widgets/monitoring.dart';

class HomeScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image(image: AssetImage('assets/logo.png'))),
      ),
      body: Text('dsds'),
    );
  }
}

/*

Image(
                    image: AssetImage('assets/news_first_load.png'),
                    fit: BoxFit.fill)
 */
