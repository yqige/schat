import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:schat/app/color/colors.dart';
import 'package:schat/app/online.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:schat/app/utils/loading.dart';
import 'package:simple_auth/simple_auth.dart';
class LoginPage extends StatefulWidget {
  final BasicAuthAuthenticator authenticator;
  LoginPage(this.authenticator);
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isWeChatInstalled = false;
  bool _isObscure = true;
  Color _eyeColor = CupertinoColors.inactiveGray;
//  final TextEditingController _userNameEditController = TextEditingController();
//  final TextEditingController _pwdEditController = TextEditingController();
  List _loginMethod = [
//    {
//      "title": "facebook",
//      "icon": GroovinMaterialIcons.facebook,
//    },
//    {
//      "title": "google",
//      "icon": GroovinMaterialIcons.google,
//    },
//    {
//      "title": "twitter",
//      "icon": GroovinMaterialIcons.twitter,
//    },
    {
      "title": "wechat",
      "icon": GroovinMaterialIcons.wechat,
    },
    {
      "title": "qqchat",
      "icon": GroovinMaterialIcons.qqchat,
    },
  ];
  @override
  void initState() {
    super.initState();
    _initFluwx();
//    _pwdEditController.addListener(() => setState(() => {}));
//    _userNameEditController.addListener(() => setState(() => {}));
  }
  _initFluwx() async {
    await fluwx.register(
        appId: "wxe5d48e88e3339efd",
        doOnAndroid: true,
        doOnIOS: true,
        enableMTA: false);
    isWeChatInstalled = await fluwx.isWeChatInstalled();
    print("is installed $isWeChatInstalled");
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(
              height: 56,
            ),
            Column(
              children: <Widget>[
                Image.asset('assets/images/login/diamond.png'),
                const SizedBox(height: 16.0),
                Text(
                  'SCHAT',
                  style: CupertinoTheme.of(context).textTheme.navTitleTextStyle
                      .apply(fontFamily: 'Raleway',),
                ),
              ],
            ),
            const SizedBox(height: 100.0),
            PrimaryColorOverride(
              color: kShrineBrown900,
              child: CupertinoTextField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.0, color: CupertinoColors.inactiveGray)),
                ),
                placeholder: '邮箱',
              ),
            ),
            const SizedBox(height: 12.0),
            PrimaryColorOverride(
              color: kShrineBrown900,
              child: CupertinoTextField(
                autofocus: false,
                controller: passwordController,
                placeholder: '密码',
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.0, color: CupertinoColors.inactiveGray)),
                ),
                suffix: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CupertinoButton(
                    color: CupertinoColors.white,
                    minSize: 0.0,
                    child: Icon(
                      CupertinoIcons.eye_solid,
                      size: 21.0,
                      color: _eyeColor,
                    ),
                    padding: const EdgeInsets.all(2.0),
                    borderRadius: BorderRadius.circular(15.0),
                    onPressed: ()=> setState(() {
                      _isObscure = !_isObscure;
                        _eyeColor = _isObscure
                        ? CupertinoColors.inactiveGray
                            : CupertinoColors.activeGreen;
                    }),
                  ),
                ),
                obscureText: _isObscure,
              ),
            ),
            _buildForgetPasswordText(context),
            const SizedBox(height: 60.0),
            _buildLoginButton(context),
            const SizedBox(height: 30.0),
            _buildOtherLoginText(),
            _buildOtherMethod(context),
//            _showLoading ? _loadingContainer : null,
//            _buildRegisterText(context),
          ],
        ),
      )
    );
  }
  Row _buildOtherMethod(BuildContext context) {
    LoadingPage loadingPage = new LoadingPage(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(
        builder: (context) {
          return CupertinoButton(
              child: Icon(item['icon'],
//                  color: Theme.of(context).iconTheme.color
                  ),
              onPressed: () {
                //TODO : 第三方登录方法
                if(!isWeChatInstalled){
                  _message("微信客户端未安装");
                }
                fluwx.sendAuth(scope: "snsapi_userinfo").then((onValue){
                  print('snsapi_userinfo:$onValue');

                });
                fluwx.responseFromAuth.listen((response){
                  //do something
                  print('response:$response');
                });
              });
        },
      ))
          .toList(),
    );
  }
  Align _buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 55.0,
        width: 270.0,
        child: CupertinoButton.filled(
          child: const Text(
            '登陆',
            style: TextStyle(fontFamily: 'Raleway'),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 36.0),
//          color: Colors.black,
          onPressed: () async{
            String _email = emailController.text, _password = passwordController.text;
            print('email:$_email , password:$_password');
            if(_email.isEmpty){
              _message('请输入邮箱!');
              return;
            }
            if(_password.isEmpty){
              _message('请输入密码!');
              return;
            }
            LoadingPage loadingPage = new LoadingPage(context);
            loadingPage.show();
            // 验证用户名及密码是否正确
            bool right = await widget.authenticator.verifyCredentials(_email, _password);
            loadingPage.close();
            print('用户名及密码是否正确--------,$right');
//            Navigator.pop(context);
            if(right){
              Navigator.push<void>(
                context,
                CupertinoPageRoute<void>(
                  builder: (BuildContext context) => new Online(),
                  maintainState: true,
                ),
              );
            }else {
              _message('邮箱或密码错误!');
            }
          },
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
  _message(String message){
    var alert =
    new CupertinoAlertDialog(
      content: Text(message),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('确定'),
          onPressed: () {
            Navigator.pop(context, 'Disallow');
          },
        )
      ],
    );
    showCupertinoDialog(
        context: context, builder: (BuildContext context) => alert);
  }

//      launch("http://www.baidu.com", forceWebView: true); // 打开新网页
  }
  Align _buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: CupertinoColors.activeGreen),
              ),
              onTap: () {
                //TODO 跳转到注册页面
                print('去注册');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Align _buildOtherLoginText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          '其他账号登录',
          style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 14.0),
        ));
  }
//  final _loadingContainer = Container(
//      constraints: BoxConstraints.expand(),
//      color: Colors.black12,
//      child: Center(
//        child: Opacity(
//          opacity: 0.9,
//          child: SpinKitCircle(
//            color: Colors.red,
//            size: 50.0,
//          ),
//        ),
//      )
//  );
  Padding _buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: CupertinoButton(
          child: Text(
            '忘记密码？',
            style: TextStyle(fontSize: 14.0, color: CupertinoColors.inactiveGray),
          ),
          onPressed: () {
//            Navigator.pop(context);
          },
        ),
      ),
    );
  }
class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child}) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      child: child,
      data: CupertinoTheme.of(context).copyWith(primaryColor: color),
    );
  }
}
