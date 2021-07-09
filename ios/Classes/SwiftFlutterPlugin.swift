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
            result(self.loginIdentity(_:result:))
        default:
            result("DEFAULT")
        }
    }

    public func initClientFromFlutter(_ call: FlutterMethodCall) -> Client {
        let clientCredentialJson = call.value(forKey: "client_credentials")
//        let clientConfig: Config = Config.encode(clientCredentialJson)
    }

    public func loginIdentity(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let completion: E3dbCompletion<Identity>
        // TODO: Add type hints
        let username: String = call.value(forKey: "username") as! String
        let password: String = call.value(forKey: "password") as! String
        let realmConfig: String = call.value(forKey: "realm_config") as! String
        
        let realm: Application = E3dbSerializer.realmFromJson(json: realmConfig)
        realm.login(username: username, password: password, actionHandler: (loginAction: IdentityLoginAction) -> [String: String], completionHandler: <#T##E3dbCompletion<Identity>##E3dbCompletion<Identity>##(E3dbResult<Identity>) -> Void#>)

}

    public func share(_ call: FlutterMethodCall, result: @escaping FlutterResult) {}

    public func writeRecord(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let client: Client
        client.write(type: "hi", data: <#T##RecordData#>, completion: <#T##E3dbCompletion<Record>##E3dbCompletion<Record>##(E3dbResult<Record>) -> Void#>)
    }
  
}
