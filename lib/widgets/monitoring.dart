import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geeklogin/constants/theme.dart';
import 'package:geeklogin/models/monitoring.dart';
import 'package:geeklogin/services/monitoring.dart';

class MonitoringWidget extends ConsumerWidget {
  final _fetchHomeInfo = FutureProvider<Monitoring>((ref) async {
    final MonitoringService monitoringService = MonitoringService();

    final monitoring = await monitoringService.fetchInfo();
    return monitoring;
  });

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    final monitoring = watch(_fetchHomeInfo).data?.value;

    final int onlineCount = monitoring?.players ?? 0;
    final String statusText = monitoring?.status ?? '...';

    return Container(
      width: double.infinity,
      color: HeaderBackgroundColor,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(children: [
              Text('Статус сервера: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('$statusText',
                  style: TextStyle(
                      color:
                          statusText == 'Online' ? Colors.green : Colors.red))
            ]),
          ),
          Row(children: [
            Text('Сейчас онлайн: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('$onlineCount выживших')
          ])
        ]),
      ),
    );
  }
}
