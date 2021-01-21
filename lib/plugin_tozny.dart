
import 'dart:async';
import 'tozny_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class PluginTozny {
  ClientCredentials credentials;

  static const MethodChannel _channel =
      const MethodChannel('plugin_tozny');

  PluginTozny(this.credentials);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<Record> readRecord(String recordID) async {
    final dynamic recordJson = await _channel.invokeMethod('readRecord',
        {"record_id": recordID,
         "client_credentials": this.credentials.toJson()
        });
    return Record.fromValidJsonString(recordJson);
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

  Future<void> share(String type, String readerID) async {
    final dynamic recordJson = await _channel.invokeMethod('share',
        {"type": type,
          "reader_id": readerID,
          "client_credentials": this.credentials.toJson()
        });
  }

  Future<void> revoke(String type, String readerID) async {
    final dynamic recordJson = await _channel.invokeMethod('revoke',
        {"type": type,
          "reader_id": readerID.toString(),
          "client_credentials": this.credentials.toJson()
        });
  }

  static Future<PluginTozny> register(String registrationToken, String clientName, {host: "https://api.e3db.com"}) async {
    final dynamic clientJson = await _channel.invokeMethod('register', 
        {"registration_token": registrationToken,
        "client_name": clientName,
        "host": host});
    return PluginTozny(ClientCredentials.fromJson(jsonDecode(clientJson)));
  }

}
