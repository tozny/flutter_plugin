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

    public init(
        clientName: String,
        clientId: String,
        apiKeyId: String,
        apiSecret: String,
        publicKey: String,
        privateKey: String,
        baseApiUrl: String,
        publicSigKey: String,
        privateSigKey: String
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
 }
