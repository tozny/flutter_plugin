import E3db

public class E3dbSerializer {
    // 
    static func realmFromJson(json: String) -> Application {
        let jsonData = json.data(using: .utf8)!
        let realmConfig: RealmConfigSerializer = try! JSONDecoder().decode(RealmConfigSerializer.self, from: jsonData)
        return Application(apiUrl: realmConfig.apiURL, appName: realmConfig.appName, realmName: realmConfig.realmName, brokerTargetUrl: realmConfig.brokenTargetURL)
    }
    
    static func idClientToJson(id: Identity) -> String {
        var data: [String: Any] = [:]

        data.updateValue(id.idConfig.storageConfig, forKey: "client_credentials")
        data.updateValue(E3dbSerializer.idConfigToJson(idConfig: id.idConfig), forKey: "identity_config")
        data.updateValue(E3dbSerializer.userAgentTokenToJson(tok: id.agentInfo()), forKey: "user_agent_token")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
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

        /// TODO: plain and fileMeta are optional values; provide a default or test that Dart can handle nil values
        let plainJsonData = try! JSONSerialization.data(withJSONObject: meta.plain!, options: .prettyPrinted)
        let plainJsonString = String(data: plainJsonData, encoding: .utf8)!

        data.updateValue(plainJsonString, forKey: "plain")
        data.updateValue(meta.fileMeta, forKey: "file_meta")
    
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
