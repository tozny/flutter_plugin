
import 'dart:async';
import 'tozny_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class PluginTozny {
  static const MethodChannel _channel =
      const MethodChannel('plugin_tozny');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Record> readRecord(String recordID, ClientCredentials creds) async {
    final dynamic recordJson = await _channel.invokeMethod('readRecord',
        {"record_id": recordID,
         "client_credentials": creds.toJson()
        });
    return Record.fromValidJsonString(recordJson);
  }

  static Future<Record> writeRecord(String type, Map<String, String> data, Map<String, String> plain, ClientCredentials creds) async {
    final dynamic recordJson = await _channel.invokeMethod('writeRecord',
        {"type": type,
         "data": data,
         "plain": plain,
         "client_credentials": creds.toJson()});
    return Record.fromValidJsonString(recordJson);
  }

  static Future<void> share(String type, String readerID, ClientCredentials creds) async {
    final dynamic recordJson = await _channel.invokeMethod('readRecord',
        {"record_id": type,
          "reader_id": readerID,
          "client_credentials": creds.toJson()
        });
  }

  static Future<void> revoke(String type, String readerID, ClientCredentials creds) async {
    final dynamic recordJson = await _channel.invokeMethod('readRecord',
        {"type": type,
          "reader_id": readerID.toString(),
          "client_credentials": creds.toJson()
        });
  }

  static Future<ClientCredentials> register(String registrationToken, String clientName, {host: "https://api.e3db.com"}) async {
    final dynamic clientJson = await _channel.invokeMethod('register', 
        {"registration_token": registrationToken,
        "client_name": clientName,
        "host": host});
    return ClientCredentials.fromJson(jsonDecode(clientJson));
  }

}
