import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schat/app/options.dart';
import 'package:schat/app/color/colors.dart';
import 'package:schat/app/scales.dart';
import 'package:schat/app/themes.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GalleryOptions _options;
  @override
  void initState() {
    super.initState();
    _options = GalleryOptions(
      theme: kLightGalleryTheme,
      textScaleFactor: kAllGalleryTextScaleValues[0],
      timeDilation: timeDilation,
      platform: defaultTargetPlatform,
    );
  }
  Widget _applyTextScaleFactor(Widget child) {
    return Builder(
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: _options.textScaleFactor.scale,
          ),
          child: child,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
//      theme: _options.theme.data.copyWith(platform: _options.platform),
      title: 'Flutter Gallery',
      color: Colors.blueAccent,
//      showPerformanceOverlay: _options.showPerformanceOverlay,
//      checkerboardOffscreenLayers: _options.showOffscreenLayersCheckerboard,
//      checkerboardRasterCacheImages: _options.showRasterCacheImagesCheckerboard,
//      routes: _buildRoutes(),
//      builder: (BuildContext context, Widget child) {
//        return Directionality(
//          textDirection: _options.textDirection,
//          child: _applyTextScaleFactor(
//            // Specifically use a blank Cupertino theme here and do not transfer
//            // over the Material primary color etc except the brightness to
//            // showcase standard iOS looks.
//            CupertinoTheme(
//              data: CupertinoThemeData(
//                brightness: _options.theme.data.brightness,
//              ),
//              child: child,
//            ),
//          ),
//        );
//      },
      home: SafeArea(
        child: Scaffold(
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              const SizedBox(height: 80.0),
              Column(
                children: <Widget>[
                  Image.asset('lib/images/login/diamond.png'),
                  const SizedBox(height: 16.0),
                  Text(
                    'SCHAT',
                    style: Theme.of(context).textTheme.headline,
                  ),
                ],
              ),
              const SizedBox(height: 120.0),
              PrimaryColorOverride(
                color: kShrineBrown900,
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: '用户名',
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              PrimaryColorOverride(
                color: kShrineBrown900,
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: '密码',
                  ),
                ),
              ),
              Wrap(
                children: <Widget>[
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('忘记密码?'),
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                      RaisedButton(
                        child: const Text('登陆'),
                        elevation: 8.0,
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        onPressed: () {
                          _toLogin();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }

  void _toLogin() {
    debugPrint('000*');
  }
}

class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child}) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(primaryColor: color),
    );
  }
}
