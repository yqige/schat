import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schat/app/call_page.dart';
import 'package:schat/app/event/userMessageResponse.dart';

import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:schat/app/common.dart';
import 'package:schat/app/utils/sendMessage.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:common_utils/common_utils.dart';
class ChatPage extends StatefulWidget {
  const ChatPage({this.color, this.colorName, this.index});
  final Color color;
  final String colorName;
  final int index;
  @override
  State<StatefulWidget> createState() => _ChatPageState();

}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _chatTextController;
  var sm = SendMessage();
  FlutterSound flutterSound = new FlutterSound();
  var _recorderSubscription;
  final List<ConversationRow> _messages = <ConversationRow>[];
  //定义发送文本事件的处理函数
  void _handleSubmitted(String text) {
    if(text.isEmpty) {
      return;
    }
    _chatTextController.clear();        //清空输入框
    sm.sendSocketMessage(text);
    if (!mounted) {
      return;
    }
    //状态变更，向聊天记录中插入新记录
    setState(() {
      _messages.insert(0, new ConversationRow(    //定义新的消息记录控件对象
        content: text,
      ));      //插入自己新的消息记录
    });
  }
  @override
  void initState() {
    super.initState();
    print('状态改变了');
    _chatTextController = TextEditingController();
    _messages.addAll(_buildConversation());
    eventBus.on<UserMessageResponse>().listen((event) {
      print("收到event>>" + event.message);
      if (!mounted) {
        return;
      }
      setState(() {
        _messages.insert(0,
            ConversationRow(
                avatar: ConversationAvatar(
                    text: '4',
                    color: Color(0xFFFD5015)),
                content:event.message));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
          debugPrint('关闭键盘...');
        },
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              trailing: trailingButtons,
            ),
            child: SafeArea(
              top: false,
              bottom: false,
              child:  new Column(             //Column使消息记录和消息输入框垂直排列
                  children: <Widget>[
                    new Flexible(                     //子控件可柔性填充，如果下方弹出输入框，使消息记录列表可适当缩小高度
                        child: new ListView.builder( // start
                          itemBuilder: (_, index) => _messages[index],
                          itemCount: _messages.length,
                          reverse: true,
                        )), // end
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                      child: _buildChatTextField(),
                    ),
                    Container(
                      color: CupertinoColors.lightBackgroundGray,
                      child: _buildOperateMethod(),
                    ),
                  ]
              ),)
        ),
      );
  }
  Row _buildOperateMethod() {
    return Row(
      children: _operateMethod
          .map((item) => Builder(
        builder: (context) {
          return CupertinoButton(
              padding: EdgeInsets.all(1.0),
              child: Icon(item['icon'],
                  color: CupertinoColors.black
              ),
              onPressed: () {
                //TODO : 第三方登录方法
                operator(item['title']);
              });
        },
      )).toList(),
    );
  }
  operator(String method) async {
    if(method.compareTo("图片") == 0){
      File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
      int timestamp = new DateTime.now().millisecondsSinceEpoch;
//        StorageReference storageReference = FirebaseStorage
//            .instance
//            .ref()
//            .child("img_" + timestamp.toString() + ".jpg");
//        StorageUploadTask uploadTask =
//        storageReference.put(imageFile);
//        Uri downloadUrl = (await uploadTask.future).downloadUrl;
      _messages.insert(0,ConversationRow(
          avatar: ConversationAvatar(
              text: '4',
              color: Color(0xFFFD5015)),
          content: imageFile,type: 1,));
    }else if(method.compareTo("语音") == 0) {
      String path = await flutterSound.startRecorder(null);
      print('startRecorder: $path');
      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
        String txt = DateUtil.getDateStrByDateTime(date, format: DateFormat.DEFAULT);
        txt = txt.substring(14,txt.length);
      });
      String result = await flutterSound.stopRecorder();
      if (_recorderSubscription != null) {
        _recorderSubscription.onData((rs){
          print('rs:$rs');
        });
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      String path_ = await flutterSound.startPlayer(result);
      print('startPlayer: $path_');
      String result_ = await flutterSound.stopPlayer();
      print('stopPlayer: $result_');
    }else if(method.compareTo("视频") == 0){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new CallPage(
                channelName: 'test',
              )));
    }else if(method.compareTo("表情") == 0){

    }
  }
  List _operateMethod = [
    {
      "title": "语音",
      "icon": CupertinoIcons.mic_solid
    },
    {
      "title": "图片",
      "icon": GroovinMaterialIcons.image,
    },
    {
      "title": "视频",
      "icon": GroovinMaterialIcons.camera,
    },
    {
      "title": "表情",
      "icon": GroovinMaterialIcons.emoticon,
    },
    {
      "title": "表情",
      "icon": GroovinMaterialIcons.plus_circle,
    },
  ];
  Widget _buildChatTextField() {
    return CupertinoTextField(
      controller: _chatTextController,
      textCapitalization: TextCapitalization.sentences,
      placeholder: 'Text Message',
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.0,
          color: CupertinoColors.inactiveGray,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      prefix: const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
      suffix: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: CupertinoButton(
          color: CupertinoColors.activeGreen,
          minSize: 0.0,
          child: const Icon(
            CupertinoIcons.up_arrow,
            size: 21.0,
            color: CupertinoColors.white,
          ),
          padding: const EdgeInsets.all(2.0),
          borderRadius: BorderRadius.circular(15.0),
          onPressed: ()=> _handleSubmitted(_chatTextController.text),
        ),
      ),
      autofocus: true,
      suffixMode: OverlayVisibilityMode.always,
      onSubmitted: (String text)=> _handleSubmitted(text),
    );
  }
}
class ContactHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        top: false,
        bottom: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE5E5E5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text(
                        'SUPPORT TICKET',
                        style: TextStyle(
                          color: Color(0xFF646464),
                          letterSpacing: -0.9,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Show More',
                        style: TextStyle(
                          color: Color(0xFF646464),
                          letterSpacing: -0.6,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Product or product packaging damaged during transit',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.46,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 16.0)),
                      const Text(
                        'REVIEWERS',
                        style: TextStyle(
                          color: Color(0xFF646464),
                          fontSize: 12.0,
                          letterSpacing: -0.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8.0)),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 44.0,
                            height: 44.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/login/diamond.png',
                                ),
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 8.0)),
                          Container(
                            width: 44.0,
                            height: 44.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/login/diamond.png',
                                ),
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 2.0)),
                          const Icon(
                            CupertinoIcons.check_mark_circled,
                            color: Color(0xFF646464),
                            size: 20.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
List<ConversationRow> _buildConversation() {
  return <ConversationRow>[
    const ConversationRow(
      content: "My Xanadu doesn't look right",
    ),
    const ConversationRow(
      avatar: ConversationAvatar(
        color: Color(0xFFFD5015),
      ),
      content: "We'll rush you a new one.\nIt's gonna be incredible",
    ),
  ];
}

class ConversationRow extends StatelessWidget {
  const ConversationRow({this.avatar, this.content, this.type = 0});

  final ConversationAvatar avatar;
  final dynamic content;
  final int type;// 0 为文本 1 为图片 2 为语音 3 为视频 4 为文档
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (avatar != null)
      children.add(avatar);
    final bool isSelf = avatar == null;
    Widget item;
    switch(type){
      case 0:
        item = Text(
          content,
          style: TextStyle(
            color: isSelf
                ? CupertinoColors.white
                : CupertinoColors.black,
            letterSpacing: -0.4,
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
          ),
          softWrap: true,
//              overflow: TextOverflow.ellipsis,
        );
        break;
      case 1:
        break;

    }
    children.add(
      ConversationBubble(
        content: item,
        color: isSelf
            ? ConversationBubbleColor.blue
            : ConversationBubbleColor.gray,
      ),
    );
    return Container(
        child: Row(
            mainAxisAlignment: isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isSelf ? CrossAxisAlignment.center : CrossAxisAlignment.end,
            children:children
        ),
      );
  }
}

enum ConversationBubbleColor {
  blue,
  gray,
}

class ConversationBubble extends StatelessWidget {
  const ConversationBubble({this.content, this.color});

  final Widget content;
  final ConversationBubbleColor color;

  @override
  Widget build(BuildContext context) {
    debugPrint('mjb:${content}');
    return
      Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            child: content,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(18.0)),
              color: color == ConversationBubbleColor.blue
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.lightBackgroundGray,
            ),
          )
      );
  }
}

class ConversationAvatar extends StatelessWidget {
  const ConversationAvatar({this.type = 1, this.text = "1", this.color});

  final String text;
  final Color color;
  final int type;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      width: 30.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/head/$text.png',
          ),
        ),
        shape: BoxShape.circle,
      ),
      margin: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      child: type == 2 ?Text(
        text,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
        ),
      ) : null,
    );
  }
}
Row _buildOtherMethod(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: _chatOperate
        .map((item) => Builder(
      builder: (context) {
        return CupertinoButton(
            child: Icon(item['icon'],
//                  color: Theme.of(context).iconTheme.color
            ),
            onPressed: () {
              //TODO :
            });
      },
    ))
        .toList(),
  );
}
List _chatOperate = [
  {
    "title": "facebook",
    "icon": GroovinMaterialIcons.facebook,
  },
  {
    "title": "google",
    "icon": GroovinMaterialIcons.google,
  },
  {
    "title": "twitter",
    "icon": GroovinMaterialIcons.twitter,
  },
  {
    "title": "twitter",
    "icon": GroovinMaterialIcons.wechat,
  },
  {
    "title": "twitter",
    "icon": GroovinMaterialIcons.qqchat,
  },
];
