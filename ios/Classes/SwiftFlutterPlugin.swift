import Flutter
import UIKit
import Foundation
import E3db

public class SwiftFlutterPlugin: NSObject, Flutter.FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugin_tozny", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS" + UIDevice.current.systemVersion)
        case "writeRecord":
            /// Platform-specific channel invocations must adhere to Flutter's main thread requirement:
            /// https://flutter.dev/docs/development/platform-integration/platform-channels#channels-and-platform-threading
            DispatchQueue.main.async {
                self.writeRecord(call, result: result)
            }
        case "loginIdentity":
            self.loginIdentity(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// Initializer to create a client from context of `FlutterMethodCall`
    ///
    /// A `FlutterConfig` object is necessary to bridge the Flutter client's `ClientCredentials`
    /// to an E3DB `Config` object.
    public func initClientFromFlutter(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> Client? {
        let args = call.arguments as! Dictionary<String, Any>
        let clientCredentialJson = args["client_credentials"] as! Dictionary<String, String>
        let jsonData = try! JSONSerialization.data(withJSONObject: clientCredentialJson, options: .prettyPrinted)
        let jsonString = String(data: jsonData, encoding: .utf8)
        let data = jsonString!.data(using: .utf8)!
        let flutterConfig: FlutterConfig = try! JSONDecoder().decode(FlutterConfig.self, from: data)
        let config: Config = FlutterConfig.encodeToE3dbConfig(flutterConfig: flutterConfig)
        let client: Client = Client(config: config)
        return client
    }

    // MARK: WRITE RECORD

    /// Writes a record using a `Client` built with values from the `FlutterMethodCall` object that
    /// persisted across `FlutterMethodChannel`.
     public func writeRecord(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let client: Client = self.initClientFromFlutter(call, result: result)!
        let args = call.arguments as! Dictionary<String, Any>
        let fields = args["data"] as! [String: String]
        let plain = args["plain"] as! [String: String]
        let recordType = args["type"] as! String
        let recordData: RecordData = RecordData(cleartext: fields)

        /// Dispatching the TozStore API call onto the global system queue to avoid "Unsupported for standard codec" error.
        /// Dispatching this asynchronous network task onto the global queue allows Grand Central Dispatch to manage the asynchronous call.
        /// Blocking the main thread allows for the API call to return to create the record which avoids the serialization error.
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            client.write(type: recordType, data: recordData, plain: plain) { (writeResult) in
                if let record = writeResult.value {
                    result(E3dbSerializer.recordToJson(record: record))
                } else {
                    result(FlutterError(code: "WRITE_RECORD", message: "Write data record failed", details: nil))
                }
            }
            group.leave()
        }
        group.wait()
    }

    func emptyActionHandler(loginAction: E3db.IdentityLoginAction) -> [String:String] {
        return [:]
    }

    /// Get the identity credentials for a user and create a client for them. The username, password and realm details are
    /// persisted from the `FlutterMethodCall` object
    public func loginIdentity(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! Dictionary<String, Any>
        let realmConfig = args["realm_config"] as! Dictionary<String,String>
        let jsonRealm = try! JSONSerialization.data(withJSONObject: realmConfig, options: .prettyPrinted)
        let stringRealm = String(data: jsonRealm, encoding: .utf8)
        let realm = E3dbSerializer.realmFromJson(json: stringRealm!)
        let username = args["username"] as! String
        let password = args["password"] as! String
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            realm.login(username: username, password: password, actionHandler: self.emptyActionHandler) { (loginResult) in
                    if let login = loginResult.value {
                        result(E3dbSerializer.idClientToJson(id: login))
                    } else {
                        result(FlutterError(code: "LOGIN", message: "login identity failed", details: nil))
                    }
                    group.leave()
                }
        }
        group.wait()
    }
}
