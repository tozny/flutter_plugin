public class RealmConfigSerializer: Codable {
    let realmName: String
    let appName: String
    let brokerTargetURL: String
    let apiURL: String
    
    enum CodingKeys: String, CodingKey {
        case realmName = "realm_name"
        case appName = "app_name"
        case brokerTargetURL = "broker_target_url"
        case apiURL = "api_url"
    }
}
