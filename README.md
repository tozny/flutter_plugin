# plugin_tozny

A work in progress flutter plugin for using [Tozny's](https://www.tozny.com) products such as TozStore and TozId to encrypt and secure data,
applications, and identities.

## Using

Use in your Dart or Flutter project by adding `plugin_tozny` as a dependency in your pubspec file:

```yaml
 plugin_tozny:
   git:
     url: git://github.com/tozny/flutter-plugin
     ref: 0.0.5
```

### End-to-end TozId Identity Registration, Login, & TozStore encrypted filed storage example

After creating a Realm (using all lowercase characters) and [Registration Token](https://www.youtube.com/watch?v=L5ieMF9JZOg), update the example values for realm_name and registration token below, and then you can run the following example function to register a new Identity for that Realm, login as that Identity, and encrypt and write data to TozStore.

 ```dart
import 'package:plugin_tozny/plugin_tozny.dart';
import 'package:plugin_tozny/plugin_identity.dart';
import 'package:plugin_tozny/plugin_realm.dart';
import 'package:plugin_tozny/tozny_model.dart';

void registerLoginStoreFileExample() async {
    RealmConfig realmConfig = new RealmConfig.fromJson({
      "realm_name": "example",
      "app_name": "account", // Only supported value at the moment
      "broker_target_url": "https://id.tozny.com/example/recover", // Default value in the form of https://<TozIdBaseURL>/<YourRealmName>/recover will use a Tozny Hosted broker compute function for password recovery flows
      "api_url": "https://api.e3db.com" // Default value for SaaS customers
    });
    var realmClient = PluginRealm(realmConfig);

    try {
      var username = 'example';
      var email = 'example@example.com'; // Note that username and password can be the same if the username is a valid email
      var password = 'StrongpassW0rd1!';
      var realmIdentity = await realmClient.register(
          username,
          password,
          '10a0cd84416e0950e345EXAMPLE813ec34a32ce1e9f76e3c192c932d2add', // Your Registration Token goes here
          email,
          'FirstName',
          'LastName',
          60);
      print("Registered Realm Identity ${realmIdentity.toJson().toString()}");

      try {
        var loggedInIdentity = await realmClient.login(username, password);
        print(
            "Logged  into Realm as Identity ${loggedInIdentity.config.toJson().toString()}");

        try {
          var absoluteFilePath = await writeExampleFile();
          var recordType = "android-gyroscope-sensor-data";
          var searchableRecordMetadata = {
            "sensor-category": "movement",
            "collection-timestamp": "1615146901",
            "anonymous-participant-id": "u-u-i-d",
          };
          var storedRecordDetails = await loggedInIdentity.client.writeFile(
              recordType, absoluteFilePath, searchableRecordMetadata);
          print("Wrote file Record ${storedRecordDetails.toJson().toString()}");

        } catch (e, s) {
          print(e);
          print(s);
        }
      } catch (e, s) {
        print(e);
        print(s);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
}

Future<String> writeExampleFile() async {
    final directory = await getApplicationDocumentsDirectory();
    var filename = "example.txt";
    final path = '${directory.path}/$filename';
    var file = new File(path);
    var sink = file.openWrite();
    sink.write('example');
    await sink.close();
    return file.absolute.path;
}
```

Running the example above after replacing the example values (realm name, registration token, username and email)
will output text similar to the below to the emulator or device console:

```text
I/flutter ( 6719): Registered Realm Identity {client_credentials: {api_key_id: fbd4b8EXAMPLE8b180a88435eec7c4e7e60e6873e820a9d, api_secret: b43de1815737df6c4EXAMPLE83ccf45991a0118c415ba3d0cd86735f, client_id: fa7da2d4-1486-41ab-8d68-accf01c27a3e, client_email: , public_key: xCNRuxVh-83qYV7WQ1EXAMPLLUygwN_-GbijgQ, private_key: yi_UZqiQ1BpYxF2X3i0kGjUmP3AmvkEXAMPL, public_signing_key: QI8-D-dl5y3bgl2CFUFIykfPJ0KaXdz505YPGpYRYeg, private_signing_key: kradKCZbLCVu0m61-rZILQtgEjqhVBRsW3MhilYLnG1Ajz4P52XnLduCXYIVQUjKR88nQppdEXAMPL, api_url: https://api.e3db.com}, identity_config: {api_url: , appName: null, broker_target_url: https://id.tozny.com/flutter/recover, realm_name: flutter, user_id: 1786, username: example2}}
I/flutter ( 6719): Logged  into Realm as Identity {client_credentials: {api_key_id: fbd4b81604971a8fa5977958c646EXAMPL7c4e7e60e6873e820a9d, api_secret: b43de1815737df6EXAMPELcf45991a0118c415ba3d0cd86735f, client_id: fa7da2d4-1486-41ab-8d68-accf01c27a3e, client_email: , public_key: xCNRuxVh-83EXAMPLCkLoLUygwN_-GbijgQ, private_key: yi_UZqiQ1BpYxF2X3i0kGjUmP3AmEXAMPL, public_signing_key: QI8-D-dl5y3bgl2CFUFIykfPJ0KaXdz505YPGpYRYeg, private_signing_key: kradKCZbLCVu0m61-rZILQtgEjqhVBRsW3MhilYLnG1Ajz4P52XnLduCXYIVQUjKR88nEXAMPL, api_url: https://api.e3db.com}, identity_config: {api_url: , appName: null, broker_target_url: https://id.tozny.com/flutter/recover, realm_name: flutter, user_id: 1786, username: example2}, user_agent_token: {access_token: eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJnTWlGYWVxMFZVRjFzN1NXTW90UzJEWU9nT0s1UC1zQ2N2UkZhcVV1N2EwIn0.eyJleHAiOjE2MTUxNjQ1NzIsImlhdCI6MTYxNTE2MDk3MiwiYXV0aF90aW1lIjoxNjE1MTYwOTcyLCJqdGkiOiI0NDI3MWRiMC00ZmFmLTQ0NzQtEXAMPL
I/flutter ( 6719): Wrote file Record {record_id: 0901582a-1ae2-4e42-8435-f74212ea86f8, writer_id: fa7da2d4-1486-41ab-8d68-accf01c27a3e, user_id: fa7da2d4-1486-41ab-8d68-accf01c27a3e, created: 2021-03-08T07:49:33.000Z, last_modified: 2021-03-08T07:49:33.000Z, version: 91af53ee-0575-4a73-bbc2-ee0803038f25, type: android-gyroscope-sensor-data, plain: {sensor-category: movement, anonymous-participant-id: u-u-i-d, collection-timestamp: 1615146901}, file: {file_url: null, file_name: 91b18cc7-cb08-4372-ac94-baab6cae31b4-1615160973, checksum: vwItq0yNXV2q/QzrhLd6Fw==, compression: RAW, size: null}}
```

## Current Limitations

* Plugin implements a partial set of all the methods and classes provided by the native SDK ([e3db-java](https://github.com/tozny/e3db-java)/[e3db-swift](https://github.com/tozny/e3db-swift)).
