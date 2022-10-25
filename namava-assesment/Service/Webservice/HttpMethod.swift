//
//  HttpMethod.swift
//  StrAIberry
//
//  Created by Vahid Ghanbarpour on 8/30/22.
//

import Foundation

enum HttpMethod {
    case get([URLQueryItem])
    case post(Data?)
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
