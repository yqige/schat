import 'dart:io';import 'package:schat/app/utils/httpUtils.dart';import 'package:schat/app/event/userMessageResponse.dart';import 'package:web_socket_channel/io.dart';import 'package:web_socket_channel/web_socket_channel.dart';class SendMessage {  static Map<String, dynamic> map = {'service':'clothes/goods_byBarcode_v2',    'openId': 'oZIqG0QiJ9nelCi5wMyOo69Ne09U',    'timestamp': '2019-6-14 18:7:36'};  static WebSocketChannel channel;  SendMessage(){    if(channel == null || channel.closeCode != null) {      channel = new IOWebSocketChannel.connect('ws://echo.websocket.org');      channel.stream.listen((data){        eventBus.fire(UserMessageResponse(data,data));      });    }  }  send(message) {    Map<String, dynamic> params = {'bizContent':{'barcode': message}};    map.addAll(params);    var res = HttpUtils().request('/bussiness/api/wechatApi',      data: map,      method: HttpUtils.POST).then((res){      eventBus.fire(UserMessageResponse(res,res));    });  }  sendSocketMessage(message) {    channel.sink.add(message);  }}