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
    
    /// Initializer to create a client from context of `FlutterMethodCall` object.
    /// Attempts to serialized client credentials from method call's "client_credentials"
    /// property and decode it into a `Config` object.
    ///
    /// `Config` is used to initialize `Client` object returned by method.
    public func initClientFromFlutter(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> Client? {
        if let args = call.arguments as? Dictionary<String, Any>,
           let clientCredentialJson = args["client_credentials"] as? Dictionary<String, String> {
            let jsonData = try? JSONSerialization.data(withJSONObject: clientCredentialJson, options: .prettyPrinted)
            let jsonString = String(data: jsonData!, encoding: .utf8)
            let data = jsonString?.data(using: .utf8)
//            let flutterConfig: FlutterConfig
            // flutterConfig.self -> knows how to serialize with sanitized credential names, has method to call client or e3db.Config constructor (return config) -> pass that into Client
            let flutterConfig: FlutterConfig = try! JSONDecoder().decode(FlutterConfig.self, from: data!)
            let config: Config = try! JSONDecoder().decode(Config.self, from: data!)
            let client: Client = Client(config: config)
            return client
        }
        return nil // TODO: Fix optional return value.
    }
    
    // MARK: WRITE RECORD
    
    /// Writes a record using a `Client` built with values from the `FlutterMethodCall` object that
    /// persisted across `FlutterMethodChannel`.
    ///
    public func writeRecord(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let client: Client = self.initClientFromFlutter(call, result: result)! // TODO: Forced unwrap will abort execution if nil is returned.
        let fields: [String: String] = call.value(forKey: "data") as! [String : String] // TODO: Too many dangerous uses of casting
        let plain: [String: String] = call.value(forKey: "value") as! [String: String]
        let recordType: String = call.value(forKey: "type") as! String
        do {
            let recordData: RecordData = RecordData(cleartext: fields)
            client.write(type: recordType, data: recordData, plain: plain) { (writeResult) in
                if let record = writeResult.value {
                    result(E3dbSerializer.recordToJson(record: record))
                } else {
                    result(FlutterError(code: "WRITE", message: "Write data record failed", details: nil)) // TODO: ERROR
                }
            }
        }
    }
}
