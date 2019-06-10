import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:schat/app/model/user.dart';
import 'package:schat/app/online.dart';
import 'package:schat/app/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = UserContainer.of(context).user;
    if (user == null) {
      return CupertinoApp(
        home: LoginPage(),
        initialRoute: '/login',
      );
    }else{
      return CupertinoApp(
        home: Online(),
      );
    }
  }
}
class CupertinoDemoDocumentationButton extends StatelessWidget {
  CupertinoDemoDocumentationButton(String routeName, { Key key })
//      : documentationUrl = kDemoDocumentationUrl[routeName],
      : documentationUrl = '',
        super(key: key);

  final String documentationUrl;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Semantics(
        label: 'API documentation',
        child: const Icon(CupertinoIcons.book),
      ),
      onPressed: () => launch(documentationUrl, forceWebView: true),
    );
  }
}
final Map<String, String> kDemoDocumentationUrl =
Map<String, String>.fromIterable(
  kAllGalleryDemos.where((GalleryDemo demo) => demo.documentationUrl != null),
  key: (dynamic demo) => demo.routeName,
  value: (dynamic demo) => demo.documentationUrl,
);
final List<GalleryDemo> kAllGalleryDemos = _buildGalleryDemos();
class GalleryDemo {
  const GalleryDemo({
    @required this.title,
    @required this.icon,
    this.subtitle,
    @required this.category,
    @required this.routeName,
    this.documentationUrl,
    @required this.buildRoute,
  }) : assert(title != null),
        assert(category != null),
        assert(routeName != null),
        assert(buildRoute != null);

  final String title;
  final IconData icon;
  final String subtitle;
  final GalleryDemoCategory category;
  final String routeName;
  final WidgetBuilder buildRoute;
  final String documentationUrl;

  @override
  String toString() {
    return '$runtimeType($title $routeName)';
  }
}

List<GalleryDemo> _buildGalleryDemos() {
  final List<GalleryDemo> galleryDemos = <GalleryDemo>[];
  return galleryDemos;
}
class GalleryDemoCategory {
  const GalleryDemoCategory._({
    @required this.name,
    @required this.icon,
  });

  final String name;
  final IconData icon;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other))
      return true;
    if (runtimeType != other.runtimeType)
      return false;
    final GalleryDemoCategory typedOther = other;
    return typedOther.name == name && typedOther.icon == icon;
  }

  @override
  int get hashCode => hashValues(name, icon);

  @override
  String toString() {
    return '$runtimeType($name)';
  }
}
