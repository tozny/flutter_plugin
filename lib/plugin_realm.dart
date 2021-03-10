
import 'dart:async';
import 'package:plugin_tozny/plugin_identity.dart';

import 'tozny_model.dart';
import 'package:flutter/services.dart';

class PluginRealm {
  static const MethodChannel _channel =
    const MethodChannel('plugin_tozny');

  RealmConfig config;
  PluginRealm(this.config);

  Future<PartialIdentityConfig> register(String username, String password, String token, String email, String firstName, String lastName, int emailEACPExpiry) async {
    final dynamic json = await _channel.invokeMethod('registerIdentity',
        {"username": username,
          "password": password,
          "token": token,
          "email": email,
          "first_name": firstName,
          "last_name": lastName,
          "email_eacp_expiry": emailEACPExpiry.toString(),
          "realm_config": this.config.toJson()
        });
    return PartialIdentityConfig.fromValidJsonString(json);
  }

  Future<PluginIdentity> login(String username, String password) async {
    final dynamic json = await _channel.invokeMethod('loginIdentity',
        {"username": username,
          "password": password,
          "realm_config": this.config.toJson()
        });
    var config = IdentityClientConfig.fromValidJsonString(json);
    return new PluginIdentity(config);
  }


}
