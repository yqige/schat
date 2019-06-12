import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactView extends StatefulWidget{
  @override
  _ContactViewState createState() => new _ContactViewState();
}
class _ContactViewState extends State{
  List<List<Object>> randomizedContacts;

  @override
  void initState() {
    super.initState();
    final Random random = Random();
    randomizedContacts = List<List<Object>>.generate(
      100,
          (int index) {
        return contacts[random.nextInt(contacts.length)]
        // Randomly adds a telephone icon next to the contact or not.
          ..add(random.nextBool().toString());
      },
    );
    randomizedContacts.insert(0, <Object>['标签',
    Icon(CupertinoIcons.tag_solid,
      color: CupertinoColors.inactiveGray,
      size: 25.0,
    ),
    ' 4/30/1789',]
    );
    randomizedContacts.insert(0, <Object>['群聊',
      Icon(CupertinoIcons.group_solid,
        color: CupertinoColors.inactiveGray,
        size: 25.0,
      ),
      ' 4/30/1789',]
    );
    randomizedContacts.insert(0, <Object>['新的朋友',
      Icon(CupertinoIcons.add,
        color: CupertinoColors.inactiveGray,
        size: 25.0,
      ),
      ' 4/30/1789',]
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new CupertinoPageScaffold(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).brightness == Brightness.light
              ? CupertinoColors.extraLightBackgroundGray
              : CupertinoColors.darkBackgroundGray,
          ),
            child: CustomScrollView(
              slivers: <Widget>[
                CupertinoSliverNavigationBar(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(left: 8.0)),
                    ],
                  ),
                ),
                SliverSafeArea(
                  top: false, // Top safe area is consumed by the navigation bar.
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return _ListItem(
                          name: randomizedContacts[index][0],
                          head: randomizedContacts[index][1],
                          forward: null,
                          index: index,
                        );
                      },
                      childCount: 20,
                    ),
                  ),
                ),
              ],
            ),
        ),
    );
  }
}
class _ListItem extends StatelessWidget {
  const _ListItem({
    this.head,
    this.name,
    this.forward,
    this.index,
  });

  final Widget head;
  final String name;
  final Widget forward;
  final int index;

  @override
  Widget build(BuildContext context) {

    return Container(
      color: index == 3 ? CupertinoColors.lightBackgroundGray : CupertinoTheme.of(context).scaffoldBackgroundColor,
      padding: index == 3 ? const EdgeInsets.only(top: 10.0) : null,
      child: Container(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        height: 50.0,
        padding: const EdgeInsets.only(top: 9.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 38.0,
              child: new Align(
                alignment: Alignment.center,
                child: head == null
                    ? Icon(
                  CupertinoIcons.phone_solid,
                  color: CupertinoColors.inactiveGray,
                  size: 25.0,
                ): head,
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
                  ),
                ),
                padding: const EdgeInsets.only(left: 1.0, bottom: 9.0, right: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            name,
//                            maxLines: 1,
//                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
List<List<Object>> contacts = <List<Object>>[
  <Object>['George Washington', null, ' 4/30/1789'],
  <Object>['John Adams', null, ' 3/4/1797'],
  <Object>['Thomas Jefferson', null, ' 3/4/1801'],
  <Object>['James Madison', null, ' 3/4/1809'],
  <Object>['James Monroe', null, ' 3/4/1817'],
  <Object>['Andrew Jackson', null, ' 3/4/1829'],
  <Object>['John Quincy Adams', null, ' 3/4/1825'],
];
