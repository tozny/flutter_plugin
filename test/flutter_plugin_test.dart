import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_tozny/plugin_tozny_ios.dart';
import 'package:plugin_tozny/tozny_model.dart';

void main() {
  const MethodChannel channel = MethodChannel('plugin_tozny');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('writeRecord', () async {
    ClientCredentials creds = ClientCredentials(apiKey: "",
                      apiSecret: "",
                      clientId: "",
                      publicKey: "",
                      privateKey: "",
                      publicSignKey: "",
                      privateSigningKey: "",
                      host: "",
                      email: "");
    var plugin = PluginToznyIOS(creds);
    var data = {"test": "example", "another": "encrypted"};
    var plain = {"plain": "hello", "search": "world"};
    expect(await plugin.writeRecord("test-data", data, plain), "42");
  });
}
