import 'package:flutter/cupertino.dart';
import 'package:schat/app/login.dart';
import 'package:schat/app/utils/instance_provider.dart';
import 'package:simple_auth_flutter/simple_auth_flutter.dart';
import 'package:simple_auth/simple_auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  BasicAuthAuthenticator authenticator;
  @override
  initState() {
    super.initState();
    SimpleAuthFlutter.init(context);
    authenticator = InstanceProvider.getAuthenticatorInstance();
  }

  @override
  Widget build(BuildContext context) {
    return new CupertinoApp(
      title: 'ScLogin',
      home: new LoginPage(authenticator),
    );
  }
}
