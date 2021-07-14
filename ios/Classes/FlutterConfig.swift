//
//  FlutterConfig.swift
//  
//
//  Created by Matthew Rhea on 7/12/21.
//

import Foundation
import E3db

/// Source: https://stackoverflow.com/questions/44396500/how-do-i-use-custom-keys-with-swift-4s-decodable-protocol
// wrapper to allow us to substitute our mapped string keys.
struct AnyCodingKey : CodingKey {

  var stringValue: String
  var intValue: Int?

  init(_ base: CodingKey) {
    self.init(stringValue: base.stringValue, intValue: base.intValue)
  }

  init(stringValue: String) {
    self.stringValue = stringValue
  }

  init(intValue: Int) {
    self.stringValue = "\(intValue)"
    self.intValue = intValue
  }

  init(stringValue: String, intValue: Int?) {
    self.stringValue = stringValue
    self.intValue = intValue
  }
}

extension JSONDecoder.KeyDecodingStrategy {
    static var convertFromFlutterConfigToE3dbConfig: JSONDecoder.KeyDecodingStrategy {
        return .custom { codingkeys in
            let key = AnyCodingKey(codingkeys.last!)
            return key
        }
    }
}

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

 extension FlutterConfig {
    /// A helper function to map FlutterConfig to an E3db Config.
    ///
    /// - Returns: A E3db Config.
    public static func encodeToE3dbConfig(flutterConfig: FlutterConfig) -> Config {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(flutterConfig)
            let decoder = JSONDecoder()
            
            /// JSONDecoder extension to map values of FlutterConfig keys to values of E3db Config keys
            decoder.keyDecodingStrategy = .convertFromFlutterConfigToE3dbConfig
            do {
                let config: Config = try decoder.decode(Config.self, from: jsonData)
                return config
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        return Config(clientName: "", clientId: UUID(), apiKeyId: "", apiSecret: "", publicKey: "", privateKey: "", baseApiUrl: URL(fileURLWithPath: ""), publicSigKey: "", privateSigKey: "")
    }
 }
