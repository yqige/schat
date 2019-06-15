import 'package:flutter/cupertino.dart';
import 'package:schat/app/home.dart';
import 'package:schat/app/user_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new CupertinoApp(
      title: 'TheGorgeousLogin',
      home: new UserContainer(user: null, child: new HomePage(),
      ),
    );
  }
}
