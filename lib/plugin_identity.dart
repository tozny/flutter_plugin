
import 'package:plugin_tozny/plugin_tozny.dart';

import 'tozny_model.dart';
import 'package:flutter/services.dart';

class PluginIdentity {
  static const MethodChannel _channel =
  const MethodChannel('plugin_tozny');

  IdentityClientConfig config;
  PluginTozny client;

  PluginIdentity(this.config) {
    this.config = config;
    this.client = PluginTozny(this.config.credentials);
  }

}
