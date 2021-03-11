
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterUmverify {
  static const MethodChannel _channel =
      const MethodChannel('flutter_umverify');


  // 初始化SDK
  static void init(String sk) {
    _channel.invokeMethod('init', {"sk": sk});
  }

  // 登录
  static void login() {
    _channel.invokeMethod('login');
  }
}
