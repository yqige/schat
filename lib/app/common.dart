import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Widget trailingButtons = Row(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
//    CupertinoDemoDocumentationButton(Online.routeName),
    const Padding(padding: EdgeInsets.only(left: 8.0)),
    const AddButton(),
  ],
);
class AddButton extends StatelessWidget {
  const AddButton();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Tooltip(
        message: 'add',
        child: Icon(CupertinoIcons.add, size: 36.0,),
        excludeFromSemantics: true,
      ),
      onPressed: () {
        // The demo is on the root navigator.
//        Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }
}
