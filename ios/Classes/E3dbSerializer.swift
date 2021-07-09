import E3db

public class E3dbSerializer {
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
        guard let jsonString = String(data: jsonData, encoding: .utf8) else { return "Something bad happened." } // TODO: Error
        return jsonString
    }

    static func recordMetaToJson(meta: Meta) -> String {
        var data: [String: Any] = [:]
        
        // TODO: Accessing meta can fail on optional values? (e.g. 'FileMeta?')
        // TODO: Check typing on these values, and do the same for the other methods.
        data.updateValue(meta.recordId, forKey: "record_id")
        data.updateValue(meta.userId, forKey: "user_id")
        data.updateValue(meta.writerId, forKey: "writer_id")
        data.updateValue(meta.created, forKey: "created")
        data.updateValue(meta.lastModified, forKey: "last_modified")
        data.updateValue(meta.version, forKey: "version")
        data.updateValue(meta.type, forKey: "type")
        
        // TODO: Implicit coercions of plain and fileMeta to 'Any'
        data.updateValue(meta.plain, forKey: "plain")
        data.updateValue(meta.fileMeta, forKey: "file_meta")
    
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else { return "Something bad happened." } // TODO: Error
        return jsonString
    }

    static func recordToJson(record: Record) -> String {
        var data: [String: Any] = [:]
        data.updateValue(E3dbSerializer.recordMetaToJson(meta: record.meta), forKey: "meta")
        data.updateValue(record.data, forKey: "data")
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else { return "Something bad happened." } // TODO: Error
        return jsonString
    }
    
    static func idConfigToJson(idConfig: IdentityConfig) -> String {
        let jsonData = try! JSONEncoder().encode(idConfig)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else { return "Something bad happened." } // TODO: ERROR HANDLING
        return jsonString
    }
    
    static func userAgentTokenToJson(tok: AgentToken) -> String {
        let jsonData = try! JSONEncoder().encode(tok)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else { return "Something bad happened." } // TODO: ERROR HANDLING
        return jsonString
    }
}
