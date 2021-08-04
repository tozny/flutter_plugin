import E3db

public class E3dbSerializer {
    // 
    static func realmFromJson(json: String) -> Application {
        let jsonData = json.data(using: .utf8)!
        let realmConfig: RealmConfigSerializer = try! JSONDecoder().decode(RealmConfigSerializer.self, from: jsonData)
        return Application(apiUrl: realmConfig.apiURL, appName: realmConfig.appName, realmName: realmConfig.realmName, brokerTargetUrl: realmConfig.brokerTargetURL)
    }
    
    static func idClientToJson(id: Identity) -> String {
        var data: [String: Any] = [:]
        data.updateValue(E3dbSerializer.configToJson(storageConfig: FlutterConfig.decodeToFlutterConfig(e3dbConfig: id.idConfig.storageConfig)), forKey: "client_credentials")
        data.updateValue(E3dbSerializer.idConfigToJson(idConfig: id.idConfig), forKey: "identity_config")
        data.updateValue(E3dbSerializer.userAgentTokenToJson(tok: id.agentInfo()), forKey: "user_agent_token")
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    static func partialIdClientToJson(id: PartialIdentity) -> String {
        var data: [String: Any] = [:]
        data.updateValue(E3dbSerializer.configToJson(storageConfig: FlutterConfig.decodeToFlutterConfig(e3dbConfig: id.idConfig.storageConfig)), forKey: "client_credentials")
        data.updateValue(E3dbSerializer.idConfigToJson(idConfig: id.idConfig), forKey: "identity_config")
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }

    static func configToJson(storageConfig: FlutterConfig) -> String {
            let jsonData = try! JSONEncoder().encode(storageConfig)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
    }
    
    static func recordMetaToJson(meta: Meta) -> String {
        var data: [String: Any] = [:]

        data.updateValue(meta.recordId.description, forKey: "record_id")
        data.updateValue(meta.userId.description, forKey: "user_id")
        data.updateValue(meta.writerId.description, forKey: "writer_id")
        data.updateValue(meta.created.description, forKey: "created")
        data.updateValue(meta.lastModified.description, forKey: "last_modified")
        data.updateValue(meta.version, forKey: "version")
        data.updateValue(meta.type, forKey: "type")

        let plainJsonData = try! JSONSerialization.data(withJSONObject: meta.plain!, options: .prettyPrinted)
        let plainJsonString = String(data: plainJsonData, encoding: .utf8)!

        data.updateValue(plainJsonString, forKey: "plain")
        data.updateValue(fileMetaToJson(meta: meta.fileMeta), forKey: "file_meta")
    
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    static func recordToJson(record: Record) -> String {
        var data: [String: Any] = [:]
        data.updateValue(E3dbSerializer.recordMetaToJson(meta: record.meta), forKey: "meta_data")
        data.updateValue(record.data, forKey: "data")
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }

    static func fileMetaToJson(meta: FileMeta?) -> String? {
        if meta == nil {
            return nil
        }
        var data: [String: Any] = [:]
        
        /// If meta is not `nil`, then assume we can force unwrap its values
        data.updateValue(meta!.fileUrl?.description, forKey: "file_url")
        data.updateValue(meta!.fileName!, forKey: "fileName")
        data.updateValue(meta!.checksum, forKey: "checksum")
        data.updateValue(meta!.compression, forKey: "compression")
        data.updateValue(meta!.size?.description, forKey: "long")
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    static func idConfigToJson(idConfig: IdentityConfig) -> String {
        let jsonData = try! JSONEncoder().encode(idConfig)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    static func userAgentTokenToJson(tok: AgentToken) -> String {
            let jsonData = try! JSONEncoder().encode(tok)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
    }
}
