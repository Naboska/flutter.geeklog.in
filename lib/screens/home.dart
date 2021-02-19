import 'package:flutter/material.dart';

import 'package:geeklogin/widgets/monitoring.dart';

class HomeScreenWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image(image: AssetImage('assets/logo.png'))),
      ),
      body: Column(children: [MonitoringWidget()]),
    );
  }
}


/*
Image(
              image: AssetImage('assets/news_first_load.png'),
              width: double.infinity,
              fit: BoxFit.fill)
 */