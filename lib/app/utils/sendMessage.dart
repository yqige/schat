import 'package:schat/app/utils/httpUtils.dart';import 'package:schat/app/event/userMessageResponse.dart';class SendMessage {  static Map<String, dynamic> map = {'service':'clothes/goods_byBarcode_v2',    'openId': 'oZIqG0QiJ9nelCi5wMyOo69Ne09U',    'timestamp': '2019-6-14 18:7:36'};  send(message) {    Map<String, dynamic> params = {'bizContent':{'barcode': message}};    map.addAll(params);    var res = HttpUtils().request('/bussiness/api/wechatApi',      data: map,      method: HttpUtils.POST).then((res){      eventBus.fire(UserMessageResponse(res));    });  }} void main(){   var res = HttpUtils().request('/wxapi/sendMsg',       data: {},       method: HttpUtils.POST).then((res){//      eventBus.fire(UserMessageResponse(res));   });}