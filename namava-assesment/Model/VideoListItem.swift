//
//  VideoListItem.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/25/22.
//

import Foundation

struct VideoListItem: Codable {
    let name: String
    let thumbnail: String
}

extension VideoListItem {
    static func resource() -> Resource<[VideoListItem]> {
        return Resource(url: URL.videoListItems, method: .get([]))
    }
}
