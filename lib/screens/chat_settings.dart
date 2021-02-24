import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:geeklogin/constants/theme.dart';

class ChatSettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  final TextEditingController _nickNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSettings();
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    super.dispose();
  }

  Future<void> _getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nickNameController.text = prefs.getString('chatNickName') ?? 'geeklogin';
  }

  Future<void> _onSaveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_nickNameController.text.length > 0)
      await prefs.setString('chatNickName', _nickNameController.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Center(child: Text('Настройки чата'))),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              Row(children: [
                Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text('Ник в чате:')),
                Expanded(
                    child: TextField(
                  controller: _nickNameController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Введите ник'),
                ))
              ]),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: RaisedButton(
                      color: PrimaryColor,
                      onPressed: _onSaveSettings,
                      child: Text('Применить')))
            ])));
  }
}
