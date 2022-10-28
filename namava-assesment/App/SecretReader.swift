//
//  SecretReader.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/26/22.
//

import Foundation

enum SecretReader: String {
    case clientIdentifier = "CLIENT_IDENTIFIER"
    case clientSecret = "CLIENT_SECRETS"
    case endpointToken = "ENDPOINT_TOKEN"
    
    static func value(for secret: SecretReader) -> String {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let value = infoDictionary[secret.rawValue] as? String
        else
        {
            fatalError("A secret named \(secret.rawValue) does not exist in VimeoConfig.xcconfig")
        }
        return value
    }
}
