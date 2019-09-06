import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage {
  final BuildContext _context;

  LoadingPage(this._context);

  ///打开loading
  void show({Function onClosed}) {
    showCupertinoDialog(
      context: _context,
      builder: (context) {
        return SpinKitFadingCircle(color: CupertinoColors.white);
      },
    ).then((value) {
      if(onClosed != null){
        onClosed(value);
      }
    });
  }

  ///关闭loading
  void close() {
    Navigator.of(_context).pop();
  }
}
