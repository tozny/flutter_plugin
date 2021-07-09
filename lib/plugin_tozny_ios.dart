import 'dart:async';
import 'tozny_model.dart';
import 'package:flutter/services.dart';

class PluginToznyIOS {
  ClientCredentials credentials;

  static const MethodChannel _channel =
      const MethodChannel('plugin_tozny');

  PluginToznyIOS(this.credentials);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<Record> writeRecord(String type, Map<String, String> data, Map<String, String> plain) async {
    final dynamic recordJson = await _channel.invokeMethod('writeRecord',
        {"type": type,
          "data": data,
          "plain": plain,
          "client_credentials": this.credentials.toJson()
        });
    return Record.fromValidJsonString(recordJson);
  }
}
