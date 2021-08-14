//
//  FlutterAgentTokenSerializer.swift
//  plugin_tozny
//
//  Created by Matthew Rhea on 8/13/21.
//

import Foundation

/// Intermediary class to convert `E3db.AgentToken.expiry` from `timeIntervalSinceReferenceDate`
/// (1 January 2001) to `timeIntervalSince1970`
public struct IntermediateFlutterAgentToken : Codable {
    public let accessToken: String
    
    public let tokenType: String
    
    public let expiry: Date
    
    public var expiryAsUnixEpoch: Int?
        
    public init(
        accessToken: String,
        tokenType: String,
        expiry: Date
    ) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiry = expiry
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiryAsUnixEpoch = "expiry_unix"
        case expiry = "expiry"
    }
}

extension IntermediateFlutterAgentToken {
    /// A helper method that returns a `[String: String]` dictionary of the `accessToken`, `tokenType`, and `expiryAsUnixEpoch`
    /// fields of the `IntermediateFlutterAgentToken` class. This should be used only after `expiryAsUnixEpoch` has been manually set
    /// as it is an optional field that is unset by `init()`.
    public static func encodeWithoutDateType(flutterAgentToken: IntermediateFlutterAgentToken) -> [String: String] {
        var data: [String: String] = [:]
        data.updateValue(flutterAgentToken.accessToken, forKey: "access_token")
        data.updateValue(flutterAgentToken.tokenType, forKey: "token_type")
        data.updateValue(String(flutterAgentToken.expiryAsUnixEpoch!), forKey: "expiry")
        return data
    }
}

/// The target class for `IntermediateFlutterAgentToken`. Use the `init()` instead of
/// decoding  to `FlutterAgentToken` from `IntermediateFlutterAgentToken` as the two
/// are incompatible due to their respective `expiry` fields being different types. 
public struct FlutterAgentToken : Codable {
    public let accessToken: String
    
    public let tokenType: String
    
    public let expiry: Int
    
    public init(
        accessToken: String,
        tokenType: String,
        expiry: Int
    ) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiry = expiry
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiry
    }
}
