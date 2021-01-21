import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:plugin_tozny/plugin_tozny.dart';
import 'package:plugin_tozny/tozny_model.dart';
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

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
    } catch(e) {
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

  void onButtonPress() async {
    String registrationToken = "TOKEN_HERE";
    try {
      var client = await register(registrationToken);
      Record writtenRecord = await writeRecord(client);
      Record tozstoreRecord = await readRecord(writtenRecord.metaData.recordID, client);
      developer.log(tozstoreRecord.toJson().toString());
    } catch(e) {
      developer.log("example flow failed because $e");
    }
  }

  Future<Record> writeRecord(PluginTozny client) async {
    try {
      var data = {"test": "example", "another": "encrypted"};
      var plain = {"plain":"hello", "search":"world"};
      var record = await client.writeRecord("testType1", data, plain);
      setState(() {
        _platformVersion = "written record: " + record.metaData.recordID;
      });
      return record;
    } catch(e) {
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
    } catch(e) {
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
        body: Stack(
          children: <Widget>[
            Center(
              child: RaisedButton(
                child: Text('Tozny Test'),
                onPressed: onButtonPress,
              ),
            ),
            Text('Running on: $_platformVersion\n'),
          ]
        ),
      ),
    );
  }
}
