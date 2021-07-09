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
        case "loginIdentity":
            result("loginIdentity")
        case "share":
            result("share")
        case "writeRecord":
            result(self.writeRecord(_:result:))
        default:
            result("DEFAULT")
        }
    }
    
    /// Initializer to create a client from context of `FlutterMethodCall` object.
    /// Attempts to serialized client credentials from method call's "client_credentials"
    /// property and decode it into a `Config` object.
    ///
    /// `Config` is used to initialize `Client` object returned by method.
    public func initClientFromFlutter(_ call: FlutterMethodCall) -> Client? {
        let clientCredentialJson = call.value(forKey: "client_credentials") as! String
        if let jsonData = clientCredentialJson.data(using: .utf8) {
            let decoder = JSONDecoder()
            let config: Config = try! decoder.decode(Config.self, from: jsonData)
            let client: Client = Client(config: config)
            return client
        }
        return nil // TODO: Fix optional return value. Likely fix is to unwrap jsonData initialization. 
    }
    
    /// Writes a record using a `Client` built with values from the `FlutterMethodCall` object that
    /// persisted across `FlutterMethodChanell`.
    ///
    public func writeRecord(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let client: Client = self.initClientFromFlutter(call)! // TODO: Forced unwrap will abort execution if nil is returned. 
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

//
//    public func loginIdentity(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//        let completion: E3dbCompletion<Identity>
//        // TODO: Add type hints
//        let username: String = call.value(forKey: "username") as! String
//        let password: String = call.value(forKey: "password") as! String
//        let realmConfig: String = call.value(forKey: "realm_config") as! String
//
//        let realm: Application = E3dbSerializer.realmFromJson(json: realmConfig)
//        realm.login(username: username, password: password, actionHandler: (loginAction: IdentityLoginAction) -> [String: String], completionHandler: <#T##E3dbCompletion<Identity>##E3dbCompletion<Identity>##(E3dbResult<Identity>) -> Void#>)
//
//}
//
//    public func share(_ call: FlutterMethodCall, result: @escaping FlutterResult) {}
//}
