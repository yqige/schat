// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schat/app/chatPage.dart';
import 'package:schat/app/common.dart';
import 'package:schat/app/contactView.dart';
import 'package:schat/app/messageItemPage.dart';
import 'package:schat/app/model/userMessage.dart';

const List<UserMessage> _userMessages = <UserMessage>[
  UserMessage(userName:'刘小妞',userPic:'',newContent:'2123', dateTime: null),
  UserMessage(userName:'🐎小宝',userPic:'',newContent:'212dsd3', dateTime: null),
  UserMessage(userName:'🐎天赐',userPic:'',newContent:'客户就开始打瞌睡', dateTime: null),
  UserMessage(userName:'刘天颍',userPic:'',newContent:'五日晚', dateTime: null),
];

const int _kChildCount = 20;

class Online extends StatelessWidget {
  Online()
      : userMessages = List<UserMessage>.generate(_kChildCount, (int index) {
    return _userMessages[math.Random().nextInt(_userMessages.length)];
  });

  static const String routeName = '/chating';

  final List<UserMessage> userMessages;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent swipe popping of this page. Use explicit exit buttons only.
      onWillPop: () => Future<bool>.value(true),
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.conversation_bubble),
                title: Text('消息'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.group_solid),
                title: Text('联系人'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled),
                title: Text('我'),
              ),
            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            assert(index >= 0 && index <= 2);
            switch (index) {
              case 0:
                return CupertinoTabView(
                  builder: (BuildContext context) {
                    return MessageTab(userMessages: userMessages,);
                  },
                  defaultTitle: '消息',
                );
                break;
              case 1:
                return CupertinoTabView(
                  builder: (BuildContext context) => ContactView(),
                  defaultTitle: '联系人',
                );
                break;
              case 2:
                return CupertinoTabView(
                  builder: (BuildContext context) => ProfileTab(),
                );
                break;
            }
            return null;
          },
        ),
      ),
    );
  }
}

class MessageTab extends StatelessWidget {
  const MessageTab({this.userMessages});

  final List<UserMessage> userMessages;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        semanticChildCount: _kChildCount,
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            trailing: trailingButtons,
          ),
          SliverPadding(
            padding: MediaQuery.of(context).removePadding(
              removeTop: true,
              removeLeft: true,
              removeRight: true,
              removeBottom: true,
            ).padding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return MessageRowItem(
                    index: index,
                    lastItem: index == _kChildCount - 1,
                    userMessage: userMessages[index],
                  );
                },
                childCount: _kChildCount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageRowItem extends StatelessWidget {
  const MessageRowItem({this.index, this.lastItem, this.userMessage});

  final int index;
  final bool lastItem;
  final UserMessage userMessage;

  @override
  Widget build(BuildContext context) {
//    return new ListTile(
//      onTap: (){
//        Navigator.of(context).push(CupertinoPageRoute<void>(
//          title: userMessage.userName,
//          builder: (BuildContext context) => MessageItemPage(
//            color: CupertinoColors.activeGreen,
//            colorName: 'M阿建博',
//            index: index,
//          ),
//        ));
//      },
//      leading: new Image.asset("assets/images/login/diamond.png",width: 40.0,height: 40.0,fit: BoxFit.cover,),
//      title: new Text(userMessage.userName),
//      subtitle: new Text(userMessage.newContent),
//      trailing: new Text('21:30'),
//    );

    final Widget row = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute<void>(
          title: userMessage.userName,
          builder: (BuildContext context) => new ChatPage(
            color: CupertinoColors.activeGreen,
            colorName: 'M阿建博',
            index: index,
          ),
        ));
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 0),
          child: Row(
            children: <Widget>[
//              new ClipOval(
//                child: Image.asset('assets/images/login/diamond.png'),
//              ),
              Container(
                height: 60.0,
                width: 60.0,
                decoration: BoxDecoration(
//                  color: color,
//                  borderRadius: BorderRadius.circular(50),
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage(userMessage.userPic))
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: [
                            Text(userMessage.userName),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                              ),
                              flex: 1,
                            ),
                            Text('15:50',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w300,
                            ),),
                          ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8.0)),
                      new Text(
                        userMessage.newContent,
                        style: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
//              CupertinoButton(
//                padding: EdgeInsets.zero,
//                child: const Icon(CupertinoIcons.plus_circled,
//                  semanticLabel: 'Add',
//                ),
//                onPressed: () { },
//              ),
//              CupertinoButton(
//                padding: EdgeInsets.zero,
//                child: const Icon(CupertinoIcons.share,
//                  semanticLabel: 'Share',
//                ),
//                onPressed: () { },
//              ),
            ],
          ),
        ),
      ),
    );

    if (lastItem) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Container(
          height: 1.0,
          color: const Color(0xFFD9D9D9),
        ),
      ],
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: trailingButtons,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).brightness == Brightness.light
              ? CupertinoColors.extraLightBackgroundGray
              : CupertinoColors.darkBackgroundGray,
        ),
        child: ListView(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 32.0)),
            GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => Tab3Dialog(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                  border: const Border(
                    top: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
                    bottom: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
                  ),
                ),
                height: 44.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: SafeArea(
                    top: false,
                    bottom: false,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Sign in',
                          style: TextStyle(color: CupertinoTheme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tab3Dialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          child: const Text('Cancel'),
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              CupertinoIcons.profile_circled,
              size: 160.0,
              color: Color(0xFF646464),
            ),
            const Padding(padding: EdgeInsets.only(top: 18.0)),
            CupertinoButton.filled(
              child: const Text('Sign in'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
