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
    public let clientId: UUID

    /// The API key identifier
    public let apiKeyId: String

    /// The API secret for making authenticated calls
    public let apiSecret: String

    /// The client's public encryption key
    public let publicKey: String

    /// The client's secret encryption key
    public let privateKey: String

    /// The base URL for the E3DB service
    public let baseApiUrl: URL

    /// The client's public signing key
    public let publicSigKey: String

    /// The client's secret signing key
    public let privateSigKey: String

    /// Initializer to customize the configuration of the client. Typically, library users will
    /// use the `Client.register(token:clientName:apiUrl:completion:)` method which will supply
    /// an initialized `Config` object. Use this initializer if you register with the other
    /// registration method, `Client.register(token:clientName:publicKey:apiUrl:completion:)`.
    /// Pass this object to the `Client(config:)` initializer to create a new `Client`.
    ///
    /// - Parameters:
    ///   - clientName: The name for this client
    ///   - clientId: The client identifier
    ///   - apiKeyId: The API key identifier
    ///   - apiSecret: The API secret for making authenticated calls
    ///   - publicKey: The client's public key
    ///   - privateKey: The client's secret key
    ///   - baseApiUrl: The base URL for the E3DB service
    public init(
        clientName: String,
        clientId: UUID,
        apiKeyId: String,
        apiSecret: String,
        publicKey: String,
        privateKey: String,
        baseApiUrl: URL,
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

// extension FlutterConfig {
//     /// A helper function to map FlutterConfig to an E3db Config.
//     ///
//     /// - Returns: A E3db Config.
//     public static func generateE3dbConfig() -> Config? {
        
//     }
// }
