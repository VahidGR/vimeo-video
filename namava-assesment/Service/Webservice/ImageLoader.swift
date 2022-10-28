//
//  ImageLoader.swift
//  StrAIberry
//
//  Created by Vahid Ghanbarpour on 8/30/22.
//

import UIKit

class ImageLoader {
    private var images: [URLRequest: LoaderStatus] = [:]
    
    public func fetch(_ path: String?) async throws -> UIImage? {
        guard let path = path else {
            return nil
        }
        guard let url = URL(string: path) else { return nil}
        let request = URLRequest(url: url)
        return try await fetch(request)
    }
    
    private func fetch(_ urlRequest: URLRequest) async throws -> UIImage? {
        if let status = images[urlRequest] {
            switch status {
            case .fetched(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            }
        }
        
        if let image = try? self.imageFromFileSystem(for: urlRequest) {
            images[urlRequest] = .fetched(image)
            return image
        }
        
        let task: Task<UIImage?, Error> = Task {
            let (imageData, _) = try await URLSession.shared.data(for: urlRequest)
            if let image = UIImage(data: imageData){
                try? self.persistImage(image, for: urlRequest)
                return image
            }
            return nil
        }
        
        images[urlRequest] = .inProgress(task)
        
        let image = try await task.value
        
        images[urlRequest] = .fetched(image)
        
        return image
    }
    
    private func persistImage(_ image: UIImage, for urlRequest: URLRequest) throws {
        guard let url = fileName(for: urlRequest),
              let data = image.jpegData(compressionQuality: 0.8) else {
            assertionFailure("Unable to generate a local path for \(urlRequest)")
            return
        }

        try? data.write(to: url)
    }
    
    private func imageFromFileSystem(for urlRequest: URLRequest) throws -> UIImage? {
        guard let url = fileName(for: urlRequest) else {
            assertionFailure("Unable to generate a local path for \(urlRequest)")
            return nil
        }
        
        print("\(url)")
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    private func fileName(for urlRequest: URLRequest) -> URL? {
        guard let fileName = urlRequest.url?.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let applicationSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                  return nil
              }
        
        let url = applicationSupport.appendingPathComponent(fileName)
        return url
    }
    
    private enum LoaderStatus {
        case inProgress(Task<UIImage?, Error>)
        case fetched(UIImage?)
    }
}
