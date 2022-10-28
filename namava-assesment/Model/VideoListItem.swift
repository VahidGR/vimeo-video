//
//  VideoListItem.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/25/22.
//

import Foundation

extension VideoList {
    static func resource(for value: String, page: String, perPage: String) -> Resource<VideoList> {
        let queries = [
            URLQueryItem(name: "q", value: value),
            URLQueryItem(name: "page", value: page),
            URLQueryItem(name: "perPage", value: perPage)
        ]
        return Resource(url: URL.videoListItems, method: .get(queries))
    }
}

struct VideoList: Codable {
    let total, page, per_page: Int?
    let paging: Paging?
    let data: [VideoListData]?
}

struct VideoListData: Codable {
    let uri, name, description: String?
    let link, player_embed_url: String?
    let duration, width: Int?
    let embed: EmbedClass?
    let height: Int?
    let pictures: Pictures?
    let stats: Stats?
    let metadata: VideoMetaData?
}

struct EmbedClass: Codable {
    let html: String?
}

struct VideoMetaData: Codable {
    let connections: PurpleConnections?
}

struct PurpleConnections: Codable {
    let comments, likes, pictures: Albums?
}

struct Albums: Codable {
    let uri: String?
    let total: Int?
}

struct Pictures: Codable {
    let uri: String?
    let base_link: String?
    let sizes: [Size?]?
}

struct Size: Codable {
    let width, height: Int?
    let link: String?
    let link_with_play_button: String?
}

struct Stats: Codable {
    let plays: Int?
}

struct Paging: Codable {
    let next: String?
    let previous: String?
    let first, last: String?
}

