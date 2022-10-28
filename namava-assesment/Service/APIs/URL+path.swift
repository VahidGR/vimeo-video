//
//  URL+path.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/25/22.
//

import Foundation

extension URL {
    
    init!(path: String, version: APIVersion? = .ver1) {
        self.init(string: WebserviceBaseURL(version: version).path)
        appendPathComponent(path)
    }
    
    init!(image path: String) {
        self.init(string: WebserviceBaseURL(path: path).path)
        appendPathComponent(path)
    }
    
}
