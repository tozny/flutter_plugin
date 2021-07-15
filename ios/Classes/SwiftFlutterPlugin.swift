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
            result(self.writeRecord(call, result: result))
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
    ///
    public func writeRecord(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let client: Client = self.initClientFromFlutter(call, result: result)!
        let args = call.arguments as! Dictionary<String, Any>
        let fields = args["data"] as! [String: String]
        let plain = args["plain"] as! [String: String]
        let recordType = args["type"] as! String
        let recordData: RecordData = RecordData(cleartext: fields)
        client.write(type: recordType, data: recordData, plain: plain) { (writeResult) in
            if let record = writeResult.value {
                result(E3dbSerializer.recordToJson(record: record))
            } else {
                result(FlutterError(code: "WRITE", message: "Write data record failed", details: nil))
            }
        }
    }
}
