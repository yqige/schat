import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:schat/app/chatScreen.dart';

class TalkCasuallyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '谈天说地',
      home: new ChatScreen(),
    );
  }

}
