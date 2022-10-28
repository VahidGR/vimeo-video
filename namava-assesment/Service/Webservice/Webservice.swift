//
//  Webservice.swift
//  StrAIberry
//
//  Created by Vahid Ghanbarpour on 8/29/22.
//

import Foundation

struct Webservice {
    func load<T: Codable>(_ resource: Resource<T>) async throws -> Result<T, NetworkError> {
        
        var request = URLRequest(url: resource.url)
        
        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                return .failure(NetworkError.badURL)
            }
            request = URLRequest(url: url)
        case .post(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data
        }
        
        // create URLSession configuration
        let configuration: URLSessionConfiguration = .default
        // add default headers
        configuration.httpAdditionalHeaders = resource.headers
        
        let session = URLSession(configuration: configuration)
        
        guard let (data, response) = try? await session.data(for: request) else {
            return .failure(NetworkError.invalidResponse)
        }
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            return .failure(NetworkError.invalidResponse)
        }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            return .failure(NetworkError.decodingError)
        }
        
        return .success(result)
        
    }
}
