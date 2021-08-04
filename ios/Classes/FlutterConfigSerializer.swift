//
//  FlutterConfig.swift
//  
//
//  Created by Matthew Rhea on 7/12/21.
//

import Foundation
import E3db

/// Configuration to bridge Flutter's ClientCredentials model to E3DB's struct.
public struct FlutterConfig: Codable {

    /// The name for this client
    public let clientName: String

    /// The client identifier
    public let clientId: String

    /// The API key identifier
    public let apiKeyId: String

    /// The API secret for making authenticated calls
    public let apiSecret: String

    /// The client's public encryption key
    public let publicKey: String

    /// The client's secret encryption key
    public let privateKey: String

    /// The base URL for the E3DB service
    public let baseApiUrl: String

    /// The client's public signing key
    public let publicSigKey: String

    /// The client's secret signing key
    public let privateSigKey: String
    
    /// The client's email
    public let email: String?

    public init(
        clientName: String,
        clientId: String,
        apiKeyId: String,
        apiSecret: String,
        publicKey: String,
        privateKey: String,
        baseApiUrl: String,
        publicSigKey: String,
        privateSigKey: String,
        email: String?
    ) {
        self.clientName = clientName
        self.clientId = clientId
        self.apiKeyId = apiKeyId
        self.apiSecret = apiSecret
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.baseApiUrl = baseApiUrl
        self.publicSigKey = publicSigKey
        self.privateSigKey = privateSigKey
        
        /// Config object in e3db-swift does not use an email, but it is expected by Flutter frontend
        /// Defaults to an empty string if `nil` to resolve error caused by force unwrapping `nil` values
        self.email = email ?? ""
    }

    /// Values for keys that map to what is expected from Flutter Dart client
    enum CodingKeys: String, CodingKey {
        case clientName    = "client_name"
        case clientId      = "client_id"
        case apiKeyId      = "api_key_id"
        case apiSecret     = "api_secret"
        case publicKey     = "public_key"
        case privateKey    = "private_key"
        case baseApiUrl    = "api_url"
        case publicSigKey  = "public_signing_key"
        case privateSigKey = "private_signing_key"
        case email         = "client_email"
    }
}

 extension FlutterConfig {
    /// A helper function to map FlutterConfig to an E3db Config.
    ///
    /// - Returns: A E3db Config.
    public static func encodeToE3dbConfig(flutterConfig: FlutterConfig) -> Config {
        let clientId: UUID = UUID(uuidString: flutterConfig.clientId)! // TODO: Forced unwrapping
        let baseApiUrl: URL = URL(string: flutterConfig.baseApiUrl)!
        let config: Config = Config(clientName: flutterConfig.clientName, clientId: clientId, apiKeyId: flutterConfig.apiKeyId, apiSecret: flutterConfig.apiSecret, publicKey: flutterConfig.publicKey, privateKey: flutterConfig.privateKey, baseApiUrl: baseApiUrl, publicSigKey: flutterConfig.publicSigKey, privateSigKey: flutterConfig.privateSigKey)
        return config
    }
    /// A helper function to map an E3db Config to FlutterConfig
    ///
    /// - Returns: FlutterConfig
    public static func decodeToFlutterConfig(e3dbConfig: Config) -> FlutterConfig {
        /// `email` in `FlutterConfig` constructor set to empty string when decoding Config object because Config does not have an `email` field
        let config: FlutterConfig = FlutterConfig(clientName: e3dbConfig.clientName, clientId: e3dbConfig.clientId.uuidString, apiKeyId: e3dbConfig.apiKeyId, apiSecret: e3dbConfig.apiSecret, publicKey: e3dbConfig.publicKey, privateKey: e3dbConfig.privateKey, baseApiUrl: e3dbConfig.baseApiUrl.absoluteString, publicSigKey: e3dbConfig.publicSigKey, privateSigKey: e3dbConfig.privateSigKey, email: "")
        return config
    }
 }
