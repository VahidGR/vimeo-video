//
//  NetworkError.swift
//  StrAIberry
//
//  Created by Vahid Ghanbarpour on 8/30/22.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case badURL
    case decodingError
}
