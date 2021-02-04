package com.tozny.plugin_tozny;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.tozny.e3db.*;
import com.fasterxml.jackson.databind.ObjectMapper;



/** PluginToznyPlugin */
public class PluginToznyPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  // Empty login handler
  private class LoginHandler implements LoginActionHandler {
      @Override
      public Map<String, Object> handleAction(LoginAction loginAction) {
          HashMap<String, Object> data = new HashMap<>();
          return data;
      }
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
      channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugin_tozny");
      channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull io.flutter.plugin.common.MethodChannel.Result result) {
      switch(call.method) {
          case "getPlatformVersion": {
              result.success("Android " + android.os.Build.VERSION.RELEASE);
          }
          break;

          case "readRecord": {
              this.readRecord(call, result);
          }
          break;

          case "writeRecord": {
              this.writeRecord(call, result);
          }
          break;

          case "writeFile": {
              this.writeFile(call, result);
          }
          break;

          case "share": {
              this.share(call, result);
          }
          break;

          case "revoke": {
              this.revoke(call, result);
          }
          break;

          case "register": {
              this.register(call, result);
          }
          break;

          case "registerIdentity": {
              this.registerIdentity(call, result);
          }
          break;

          case "loginIdentity": {
              this.loginIdentity(call, result);
          }
          break;

          default: {
              result.notImplemented();
          }
          break;
      }

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  public Client initClientFromFlutter(@NonNull MethodCall call) throws E3DBCryptoException, IOException {
      HashMap clientCredentialJson = call.argument("client_credentials");
      Config clientConfig = Config.fromJson(new ObjectMapper().writeValueAsString(clientCredentialJson));
      return new ClientBuilder().fromConfig(clientConfig).build();
  }

  public Realm initRealmFromFlutter(@NonNull MethodCall call) throws E3DBCryptoException, IOException {
      HashMap json = call.argument("realm_config");
      Realm realm = E3dbSerializer.realmFromJson(new ObjectMapper().writeValueAsString(json));
      return realm;
  }

  public void readRecord(@NonNull MethodCall call, @NonNull final io.flutter.plugin.common.MethodChannel.Result result) {
      try {
          String recordID = call.argument("record_id");
          Client client = this.initClientFromFlutter(call);
          try {
              client.read(UUID.fromString(recordID), new ResultHandler<Record>() {
                  @Override
                  public void handle(com.tozny.e3db.Result<Record> r) {
                      if(!r.isError()) {
                          Record record = r.asValue();
                          result.success(E3dbSerializer.recordToJson(record));
                      } else {
                          result.error("ReadRecordError", r.asError().other().getMessage(), null);
                      }
                  }
              });
          } catch (Exception e) {
              result.error("GenericSDKError", e.getMessage(), null);
          }
      } catch (Exception e) {
          result.error("ParsingFieldsError", e.getMessage(), null);
      }
  }

  public void register(@NonNull MethodCall call, @NonNull final io.flutter.plugin.common.MethodChannel.Result result) {
      try {
          String registrationToken = call.argument("registration_token");
          String clientName = call.argument("client_name");
          String host = call.argument("host");
          try {
              Client.register(registrationToken, clientName, host, new ResultHandler<Config>() {
                  @Override
                  public void handle(com.tozny.e3db.Result<Config> r) {
                      if(!r.isError()) {
                          Config mConfig = r.asValue();
                          result.success(mConfig.json());
                      }
                      else {
                          result.error("RegistrationError", r.asError().other().getMessage(), null);
                      }
                  }
              });
          } catch (Exception e) {
              result.error("GenericSDKError", e.getMessage(), null);
          }
      } catch (Exception e) {
          result.error("ParsingFieldsError", e.getMessage(), null);
      }
  }

  public void registerIdentity(@NonNull final MethodCall call, @NonNull final io.flutter.plugin.common.MethodChannel.Result result) {
      try {
          String username = call.argument("username");
          String password = call.argument("password");
          String token = call.argument("token");
          String email = call.argument("email");
          String firstName = call.argument("first_name");
          String lastName = call.argument("last_name");
          String emailEACPExpiry = call.argument("email_eacp_expiry");
          try {
              HashMap json = call.argument("realm_config");
              Realm realm = E3dbSerializer.realmFromJson(new ObjectMapper().writeValueAsString(json));
              realm.register(username, password, token, email, firstName, lastName, Integer.parseInt(emailEACPExpiry), new ResultHandler<PartialIdentityClient>() {
                   @Override
                   public void handle(com.tozny.e3db.Result<PartialIdentityClient> r) {
                      if(!r.isError()) {
                          PartialIdentityClient idClient = r.asValue();
                          result.success(E3dbSerializer.partialIdClientToJson(idClient));
                      }
                      else {
                          result.error("IdentityRegistrationError", r.asError().other().getMessage(), null);
                      }
                  }
              });
          } catch (Exception e) {
              result.error("GenericSDKError", e.getMessage(), null);
          }
      } catch (Exception e) {
          result.error("ParsingFieldsError", e.getMessage(), null);
      }

  }

  public void loginIdentity(@NonNull final MethodCall call, @NonNull final io.flutter.plugin.common.MethodChannel.Result result) {
      try {
          String username = call.argument("username");
          String password = call.argument("password");
          try {
              HashMap json = call.argument("realm_config");
              Realm realm = E3dbSerializer.realmFromJson(new ObjectMapper().writeValueAsString(json));

              realm.login(username, password, new LoginHandler(), new ResultHandler<IdentityClient>() {
                  @Override
                  public void handle(com.tozny.e3db.Result<IdentityClient> r) {
                      if(!r.isError()) {
                          IdentityClient idClient = r.asValue();
                          result.success(E3dbSerializer.idClientToJson(idClient));
                      }
                      else {
                          result.error("IdentityLoginError", r.asError().other().getMessage(), null);
                      }
                  }
              });
          } catch (Exception e) {
              result.error("GenericSDKError", e.getMessage(), null);
          }
      } catch (Exception e) {
          result.error("ParsingFieldsError", e.getMessage(), null);
      }
  }

    public void writeRecord(@NonNull MethodCall call, @NonNull final io.flutter.plugin.common.MethodChannel.Result result) {
        try {
            Client client = this.initClientFromFlutter(call);
            HashMap<String, String> fields = call.argument("data");
          HashMap<String, String> plain = call.argument("plain");
          String recordType = call.argument("type");
          try {
              RecordData data = new RecordData(fields);
              client.write(recordType, data, plain, new ResultHandler<Record>() {
                  @Override
                  public void handle(com.tozny.e3db.Result<Record> r) {
                      if(!r.isError()) {
                          Record record = r.asValue();
                          result.success(E3dbSerializer.recordToJson(record));
                      } else {
                          result.error("WriteRecordError", r.asError().other().getMessage(), null);
                      }
                  }
              });
          } catch (Exception e) {
              result.error("GenericSDKError", e.getMessage(), null);
          }
      } catch (Exception e) {
          result.error("ParsingFieldsError", e.getMessage(), null);
      }
  }

  public void writeFile(@NonNull MethodCall call, @NonNull final io.flutter.plugin.common.MethodChannel.Result result) {
      try {
          Client client = this.initClientFromFlutter(call);
          HashMap<String, String> plain = call.argument("plain");
          String filePath = call.argument("file_path");
          String recordType = call.argument("type");

          try {
              File file = new File(filePath);
              client.writeFile(recordType, file, plain, new ResultHandler<RecordMeta>() {
                    @Override
                    public void handle(com.tozny.e3db.Result<RecordMeta> r) {
                      if(!r.isError()) {
                          RecordMeta meta = r.asValue();
                          result.success(E3dbSerializer.recordMetaToJson(meta));
                      } else {
                          result.error("WriteRecordError", r.asError().other().getMessage(), null);
                      }
          }
          });
          } catch (Exception e) {
              result.error("GenericSDKError", e.getMessage(), null);
          }
      } catch (Exception e) {
          result.error("ParsingFieldsError", e.getMessage(), null);
      }
  }

  public void share(@NonNull MethodCall call, @NonNull final io.flutter.plugin.common.MethodChannel.Result result) {
      try {
          Client client = this.initClientFromFlutter(call);
          String recordType = call.argument("type");
          String readerID = call.argument("reader_id");
          try {
              client.share(recordType, UUID.fromString(readerID),  new ResultHandler<Void>() {
                  @Override
                  public void handle(com.tozny.e3db.Result<Void> r) {
                      if(!r.isError()) {
                          result.success(null);
                      } else {
                          result.error("ShareError", r.asError().other().getMessage(), null);
                      }
                  }
              });
          } catch (Exception e) {
              result.error("GenericSDKError", e.getMessage(), null);
          }
      } catch (Exception e) {
          result.error("ParsingFieldsError", e.getMessage(), null);
      }
  }

  public void revoke(@NonNull MethodCall call, @NonNull final io.flutter.plugin.common.MethodChannel.Result result) {
      try {
          Client client = this.initClientFromFlutter(call);
          String recordType = call.argument("type");
          String readerID = call.argument("reader_id");
          try {
              client.revoke(recordType, UUID.fromString(readerID), new ResultHandler<Void>() {
                  @Override
                  public void handle(com.tozny.e3db.Result<Void> r) {
                      if(!r.isError()) {
                          result.success(null);
                      } else {
                          result.error("RevokeError", r.asError().other().getMessage(), null);
                      }
                  }
              });
          } catch (Exception e) {
              result.error("GenericSDKError", e.getMessage(), null);
          }
      } catch (Exception e) {
          result.error("ParsingFieldsError", e.getMessage(), null);
      }
  }

}
