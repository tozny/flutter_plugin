import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plugin_tozny/plugin_realm.dart';
import 'package:plugin_tozny/plugin_tozny.dart';
import 'package:plugin_tozny/tozny_model.dart';
import 'package:plugin_tozny/plugin_identity.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _loggedInIdentity = "None";
  String _publicSigningKey = "None";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await PluginTozny.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    } catch (e) {
      platformVersion = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void onWriteRecordButtonPress() async {
    var creds = ClientCredentials(apiKey: "",
                                  apiSecret: "",
                                  clientId: "",
                                  publicKey: "",
                                  privateKey: "",
                                  publicSignKey: "",
                                  privateSigningKey: "",
                                  host: "",
                                  email: "",
                                  clientName: "");
    var client = PluginTozny(creds);
    try {
      Record writtenRecord = await writeRecord(client);
      Record tozstoreRecord =
          await readRecord(writtenRecord.metaData.recordID, client);
      developer.log(tozstoreRecord.toJson().toString());
      developer.log("example flow succeeded");
    } catch (e) {
      developer.log("example flow failed becaused $e");
    }
  }

  void loginOnButtonPress() async {
    String apiUrl = "https://api.e3db.com";
    String appName = "account";
    String realmName = "example";
    String brokerTargetUrl = "https://id.tozny.com/example/recover";
    String username = "user@name.com";
    String password = "passW0rd!";

    try {
      var realmCreds = RealmConfig(realmName: realmName, appName: appName, apiURL: apiUrl, brokerTargetURL: brokerTargetUrl);
      var realm = PluginRealm(realmCreds);
      PluginIdentity logRes = await loginIdentity(realm, username, password);
      developer.log("login succeeded for $logRes");
    } catch (e) {
      developer.log("example flow failed because $e");
    }
  }
  
  void writeFileOnButtonPress() async {
    var creds = ClientCredentials(apiKey: "", 
                                  apiSecret: "",
                                  clientId: "",
                                  publicKey: "",
                                  privateKey: "",
                                  publicSignKey: "",
                                  privateSigningKey: "",
                                  host: "",
                                  email: "",
                                  clientName: "");
    var client = PluginTozny(creds);
    try {
      RecordMeta writtenFileMeta = await writeFile(client);
      // verify the record was created & can be read
      Record fileRecord = await readRecord(writtenFileMeta.recordID, client);
      developer.log("write file succeeded: $writtenFileMeta");
    } catch(e) {
      developer.log("example write file flow failed because $e");
    }
  }

  void onWriteThenShareRecordButtonPress() async {
    var creds = ClientCredentials(apiKey: "", 
                                  apiSecret: "",
                                  clientId: "",
                                  publicKey: "",
                                  privateKey: "",
                                  publicSignKey: "",
                                  privateSigningKey: "",
                                  host: "",
                                  email: "",
                                  clientName: "");
    var client = PluginTozny(creds);
    var recordType = "testType1";
    var readerID = "";
    try {
      Record writtenRecord = await writeRecord(client);
      await share(client, recordType, readerID);
      await revoke(client, recordType, readerID);
      developer.log("write, share, then revoke record flow succeeded");
    } catch (e) {
      developer.log("example share flow failed becaused $e");
    }
  }

  void onButtonPress() async {
    String registrationToken = "TOKEN_HERE";
    try {
      var client = await register(registrationToken);
      if (await Permission.storage.request().isGranted) {
        var resp = writeFile(client);
      } else {
        await Permission.storage.request();
      }
      Record writtenRecord = await writeRecord(client);
      Record tozstoreRecord =
          await readRecord(writtenRecord.metaData.recordID, client);
      developer.log(tozstoreRecord.toJson().toString());
    } catch (e) {
      developer.log("example flow failed because $e");
    }
  }

  void registerIdentityAndLogin(RealmConfig config, String regToken) async {
    var realmClient = new PluginRealm(config);
    Random random = new Random();
    var username = random.nextInt(10000).toString();
    try {
      print("before register");
      await realmClient.register(
          username, "pass", regToken, "test@example.com", "test", "user", 60);
      print("logging in");
      var loggedInIdentity = await realmClient.login(username, "pass");
      print("writing record with identity");
      var record = await writeRecord(loggedInIdentity.client);
      print(record.toJson().toString());
    } catch (e) {
      print("error $e");
    }
  }

  Future<void> share(PluginTozny client, String type, String readerID) async {
    try {
      await client.share(type, readerID);
      setState(() {
        _platformVersion = "shared record: " + type;
      });
    } catch (e) {
      developer.log("Share record failed because " + e.toString());
    }
  }

  Future<void> revoke(PluginTozny client, String type, String readerID) async {
    try {
      await client.revoke(type, readerID);
      setState(() {
        _platformVersion = "revoked record: " + type;
      });
    } catch (e) {
      developer.log("Revoking record failed because " + e.toString());
    }
  }

  Future<RecordMeta> writeFile(PluginTozny client) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      var filename = "test_file.txt";
      final path = '${directory.path}/$filename';
      var file = new File(path);
      var sink = file.openWrite();
      sink.write('some encrypted content');
      await sink.close();
      var plain = {"plain": "file"};
      developer.log(file.absolute.path);
      var recordMeta =
          await client.writeFile("testFileType1", file.absolute.path, plain);
      setState(() {
        _platformVersion = "written file record: " + recordMeta.recordID;
      });
      return recordMeta;
    } catch (e) {
      developer.log("sdkfjlaskjdf" + e.toString());
    }
  }

  Future<Record> writeRecord(PluginTozny client) async {
    try {
      var data = {"test": "example", "another": "encrypted"};
      var plain = {"plain": "hello", "search": "world"};
      var record = await client.writeRecord("testType1", data, plain);
      setState(() {
        _platformVersion = "written record: " + record.metaData.recordID;
      });
      return record;
    } catch (e) {
      developer.log(e.toString());
    }
  }

  Future<PluginIdentity> loginIdentity(PluginRealm realm, String username, String password) async {
    try {
      var loggedInIdentity = await realm.login(username, password);
      setState(() {
        _loggedInIdentity = loggedInIdentity.client.credentials.clientName;
        _publicSigningKey = loggedInIdentity.client.credentials.publicSignKey;
      });
      return loggedInIdentity;
    } catch (e) {
      developer.log(e.toString());
    }
  }

  Future<Record> readRecord(String recordID, PluginTozny client) async {
    try {
      var record = await client.readRecord(recordID);
      setState(() {
        _platformVersion = "read record";
      });
      return record;
    } catch (e) {
      developer.log("found error");
      developer.log(e.toString());
    }
  }

  Future<PluginTozny> register(String regToken) async {
    var client = await PluginTozny.register(regToken, "flutter_test_client");
    setState(() {
      _platformVersion = "registered client";
    });
    return client;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Stack(children: <Widget>[
          Center(
            child: RaisedButton(
              child: Text('Tozny Test'),
              onPressed: loginOnButtonPress,
            ),
          ),
          Column(
            children: [
            Text('Running on: $_platformVersion'),
            Text('Logged in identity: $_loggedInIdentity'),
            Text('public signing key: $_publicSigningKey'),
          ],),
        ]),
      ),
    );
  }
}
