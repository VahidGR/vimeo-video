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
    case image(path: String)
    
    var path: String {
        let endpointToken = SecretReader.value(for: .endpointToken)
        switch self {
            
        case .dev(let version):
            if let version = version {
                return "https://v\(version.rawValue).nocodeapi.com/vahidgr/vimeo/\(endpointToken)"
            }
            return "https://v1.nocodeapi.com/vahidgr/vimeo/\(endpointToken)"
            
        case .production(let version):
            if let version = version {
                return "https://v\(version.rawValue).nocodeapi.com/vahidgr/vimeo/\(endpointToken)"
            }
            return "https://v1.nocodeapi.com/vahidgr/vimeo/\(endpointToken)"
            
        case .image(let path):
            return "https://i.vimeocdn.com\(path)"
        }
    }
    
    init(version: APIVersion? = nil) {
        #if DEV
        self = .dev(version: version)
        #else
        self = .production(version: version)
        #endif
    }
    
    init(path: String) {
        self = .image(path: path)
    }
    
}
