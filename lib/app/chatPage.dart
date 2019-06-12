import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:schat/app/common.dart';

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
  final List<Widget> _messages = <Widget>[];
  //定义发送文本事件的处理函数
  void _handleSubmitted(String text) {
    if(text.isEmpty) {
      return;
    }
    _chatTextController.clear();        //清空输入框
    ConversationRow message = new ConversationRow(    //定义新的消息记录控件对象
      text: text,
    );
    //状态变更，向聊天记录中插入新记录
    setState(() {
      _messages.insert(0, message);      //插入新的消息记录
    });
  }
  @override
  void initState() {
    super.initState();
    _chatTextController = TextEditingController();
    _messages.addAll(_buildConversation());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
                padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                child: _buildChatTextField(),
              )
            ]
        ),)
    );
  }
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
List<Widget> _buildConversation() {
  return <Widget>[
    const ConversationRow(
      text: "My Xanadu doesn't look right",
    ),
    const ConversationRow(
      avatar: ConversationAvatar(
        text: 'KL',
        color: Color(0xFFFD5015),
      ),
      text: "We'll rush you a new one.\nIt's gonna be incredible",
    ),
    const ConversationRow(
      text: 'Awesome thanks!',
    ),
    const ConversationRow(
      avatar: ConversationAvatar(
        text: 'SJ',
        color: Color(0xFF34CAD6),
      ),
      text: "We'll send you our\nnewest Labrador too!",
    ),
    const ConversationRow(
      text: 'Yay',
    ),
    const ConversationRow(
      avatar: ConversationAvatar(
        text: 'KL',
        color: Color(0xFFFD5015),
      ),
      text: "Actually there's one more thing...",
    ),
    const ConversationRow(
      text: "What's that?",
    ),
  ];
}

class ConversationRow extends StatelessWidget {
  const ConversationRow({this.avatar, this.text});

  final ConversationAvatar avatar;
  final String text;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (avatar != null)
      children.add(avatar);

    final bool isSelf = avatar == null;
    children.add(
      Tab2ConversationBubble(
        text: text,
        color: isSelf
            ? Tab2ConversationBubbleColor.blue
            : Tab2ConversationBubbleColor.gray,
      ),
    );
    return SafeArea(
      child: Row(
        mainAxisAlignment: isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isSelf ? CrossAxisAlignment.center : CrossAxisAlignment.end,
        children: children,
      ),
    );
  }
}

enum Tab2ConversationBubbleColor {
  blue,
  gray,
}

class Tab2ConversationBubble extends StatelessWidget {
  const Tab2ConversationBubble({this.text, this.color});

  final String text;
  final Tab2ConversationBubbleColor color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(18.0)),
        color: color == Tab2ConversationBubbleColor.blue
            ? CupertinoColors.activeBlue
            : CupertinoColors.lightBackgroundGray,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: Text(
        text,
        style: TextStyle(
          color: color == Tab2ConversationBubbleColor.blue
              ? CupertinoColors.white
              : CupertinoColors.black,
          letterSpacing: -0.4,
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class ConversationAvatar extends StatelessWidget {
  const ConversationAvatar({this.text, this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: <Color>[
            color,
            Color.fromARGB(
              color.alpha,
              (color.red - 60).clamp(0, 255),
              (color.green - 60).clamp(0, 255),
              (color.blue - 60).clamp(0, 255),
            ),
          ],
        ),
      ),
      margin: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
        ),
      ),
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
