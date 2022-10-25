//
//  WebserviceBaseURL.swift
//  StrAIberry
//
//  Created by Vahid Ghanbarpour on 8/30/22.
//

import Foundation

enum WebserviceBaseURL {
    
    case dev(version: APIVersion?)
    case production(version: APIVersion?)
    case image(id: String)
    
    var path: String {
        switch self {
            
        case .dev(let version):
            if let version = version {
                return "https://api.dev.straiberry.com/api/v\(version.rawValue)/"
            }
            return "https://api.dev.straiberry.com/api/"
            
        case .production(let version):
            if let version = version {
                return "https://api.straiberry.com/api/v\(version.rawValue)/"
            }
            return "https://api.straiberry.com/api/"
            
        case .image(let id):
            return "https://api.dev.straiberry.com/\(id)"
        }
    }
    
    init(version: APIVersion? = nil) {
        #if DEV
        self = .dev(version: version)
        #else
        self = .production(version: version)
        #endif
    }
    
    init(id: String) {
        self = .image(id: id)
    }
    
}
