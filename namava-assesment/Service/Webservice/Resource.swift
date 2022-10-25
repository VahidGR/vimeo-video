//
//  Resource.swift
//  StrAIberry
//
//  Created by Vahid Ghanbarpour on 8/30/22.
//

import Foundation

struct Resource<T: Codable> {
    let url: URL
    var headers: [String: String] = ["Content-Type": "application/json"]
    var method: HttpMethod = .get([])
    var requireAuthentication: Bool = true
}
