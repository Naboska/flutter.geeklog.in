import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:geeklogin/models/chat.dart';
import 'package:geeklogin/constants/api.dart';
import 'package:geeklogin/constants/theme.dart';
import 'package:geeklogin/services/chat.dart';
import 'package:geeklogin/screens/chat_settings.dart';

class ChatScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {
  List<Chat> _messages;
  bool _isLoading;
  bool _isSendMessage;

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = new ScrollController();

  IO.Socket socket = IO.io(PUBLIC_SERVER_API, <String, dynamic>{
    'path': '$SERVER_PATH/socket.io',
    'transports': ['websocket'],
  });

  Future<void> _onSendChatMessage() async {
    if (_textController.text.length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      try {
        setState(() => _isSendMessage = true);
        await sendChatPost(
            message: _textController.text,
            userName: prefs.getString('chatNickName') ?? 'geeklogin');
        if (mounted) _textController.text = '';
      } catch (e) {}
      if (mounted) setState(() => _isSendMessage = false);
    }
  }

  Future<void> _fetchAllChat() async {
    try {
      setState(() => _isLoading = true);
      final response = await fetchChat();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _messages.addAll(response);
        });

        Timer(
            Duration(milliseconds: 20),
            () => _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                ));
      }
    } catch (e) {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isSendMessage = false;
    _messages = [];

    _fetchAllChat();

    socket.on('chat', (m) {
      final Chat message = parseChatMessage(m);

      if (mounted) {
        setState(() {
          _messages.add(message);
        });

        if (_scrollController.offset + 50.0 >
            _scrollController.position.maxScrollExtent)
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _parseDate(String date) {
    final DateTime current = DateTime.parse(date).toLocal();
    final int hour = current.hour;
    final int minute = current.minute;

    return '$hour:$minute';
  }

  Widget getChat() {
    if (_isLoading)
      return Container(
          constraints: BoxConstraints.expand(),
          child: Center(child: CircularProgressIndicator()));

    if (_messages.length == 0)
      return Container(
          constraints: BoxConstraints.expand(),
          child: Center(child: Text('Пока сообщений нет')));

    return Align(
        alignment: Alignment.bottomLeft,
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 50),
            itemCount: _messages.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              final Chat item = _messages[index];
              final String firstName = item.userName[0].toUpperCase();
              final String lastName = item.userName[1].toUpperCase();
              final String currentDate = _parseDate(item.date);

              final bool isOldAuthor =
                  index > 0 && _messages[index - 1].userName == item.userName;
              final bool isNextAuthorNew = index == _messages.length - 1 ||
                  index != _messages.length - 1 &&
                      _messages[index + 1].userName != item.userName;

              return Padding(
                  padding: EdgeInsets.only(
                      top: index == 0 ? 0 : 0,
                      bottom: isNextAuthorNew ? 10 : 0,
                      right: 5),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding:
                                EdgeInsets.only(left: 4, right: 8, bottom: 0),
                            child: Container(
                                width: 40,
                                height: isOldAuthor ? 0 : 40,
                                decoration: isOldAuthor
                                    ? null
                                    : BoxDecoration(
                                        color: NewsBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                child: isOldAuthor
                                    ? Container(width: 0)
                                    : Center(
                                        child: Text('$firstName$lastName',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: PrimaryColor))))),
                        Flexible(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: NewsBackgroundColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          isOldAuthor ? 0.0 : 10.0),
                                      topRight: Radius.circular(
                                          isOldAuthor ? 0.0 : 10.0),
                                      bottomLeft: Radius.circular(
                                          isNextAuthorNew ? 10.0 : 0.0),
                                      bottomRight: Radius.circular(
                                          isNextAuthorNew ? 10.0 : 0.0),
                                    )),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: isOldAuthor ? 0 : 10.0,
                                      bottom: !isOldAuthor ? 0 : 5.0,
                                      right: 10.0,
                                      left: 10.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        isOldAuthor
                                            ? Container(width: 0)
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 5.0),
                                                child: Text(item.userName,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: PrimaryColor))),
                                        Text(item.message),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 6, bottom: 2),
                                            child: isNextAuthorNew
                                                ? Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(currentDate,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                NewsTextColor)))
                                                : Container())
                                      ]),
                                )))
                      ]));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Чат сервера')),
          actions: [
            Container(
                width: 40,
                child: RaisedButton(
                  padding: EdgeInsets.all(0.0),
                  color: PrimaryColor,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatSettingsScreen()));
                  },
                  child: Icon(
                    Icons.settings,
                    size: 15,
                  ),
                ))
          ],
        ),
        body: Stack(children: [
          getChat(),
          Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  color: ScaffoldBackgroundColor,
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  child: Row(children: [
                    Expanded(
                        child: TextField(
                      controller: _textController,
                      enabled: !_isLoading && !_isSendMessage,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Введите сообщение...'),
                    )),
                    FloatingActionButton(
                      backgroundColor: ScaffoldBackgroundColor,
                      onPressed: !_isSendMessage ? _onSendChatMessage : null,
                      child: _isSendMessage
                          ? CircularProgressIndicator()
                          : Icon(Icons.send, size: 13),
                      elevation: 0,
                    ),
                  ])))
        ]));
  }
}
