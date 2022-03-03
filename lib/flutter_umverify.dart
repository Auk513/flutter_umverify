
import 'dart:async';

import 'package:flutter/services.dart';


class FlutterUmverify {
  static const String flutter_log = "| UMVERIFY | Flutter | ";
  

  static const MethodChannel _channel =
      const MethodChannel('flutter_umverify');

  Function(String) tokenCallback = (value) => {};
  Function changeBtnCallback = () => {};
  Function appleCallback = () => {};

  loginWithToken(Function(String) callback) {
    tokenCallback = callback;
  }

  loginWithChangeBtn(Function callback) {
    changeBtnCallback = callback;
  }

  loginWithApple(Function callback) {
    appleCallback = callback;
  }

  Future<Map<dynamic, dynamic>> setup(String sdkInfo) async {
    print("$flutter_log" + "setup");
    _channel.setMethodCallHandler(_handlerMethod);
    return await _channel.invokeMethod('setup', {"sdkInfo": sdkInfo});
  }

  /*
   * SDK判断网络环境是否支持
   *
   * return Map
   *          key = "result"
   *          vlue = bool,是否支持
   * */
  Future<Map<dynamic, dynamic>> checkVerifyEnable() async {
    print("$flutter_log" + "checkVerifyEnable");
    return await _channel.invokeMethod("checkVerifyEnable");
  }

  /*
  * SDK请求授权一键登录（异步接口）
  *
  * @return 通过接口异步返回的 map :
  *                           key = "code", value = 6000 代表loginToken获取成功
  *                           key = message, value = 返回码的解释信息，若获取成功，内容信息代表loginToken
  *
  * @discussion since SDK v2.4.0，授权页面点击事件监听：通过添加 JVAuthPageEventListener 监听，来监听授权页点击事件
  *
  * */
  Future<Map<dynamic, dynamic>> loginAuth() async {
    print("$flutter_log" + "loginAuth");
    return await _channel.invokeMethod("loginAuth");
  }

  Future<void> dismiss() async {
    print("$flutter_log" + "dismiss");
    return await _channel.invokeMethod("dismiss");
  }

  Future<void> _handlerMethod(MethodCall call) async {
    print("handleMethod method = ${call.method}");
    switch (call.method) {
      case 'loginWithToken':
        {
          tokenCallback(call.arguments['token']);
        }
        break;
      case 'loginWithChangeBtn':
        {
          dismiss();
          changeBtnCallback();
        }
        break;
      case 'loginWithApple':
        {
          appleCallback();
        }
        break;
    }
  }

}
