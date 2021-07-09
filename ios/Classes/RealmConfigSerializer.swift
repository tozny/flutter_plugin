public class RealmConfigSerializer: Codable {
    let realmName: String
    let appName: String
    let brokenTargetURL: String
    let apiURL: String
    
    enum CodingKeys: String, CodingKey {
        case realmName = "realm_name"
        case appName = "app_name"
        case brokenTargetURL = "broken_target_url"
        case apiURL = "api_url"
    }
}
