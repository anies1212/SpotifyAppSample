//
//  FeaturedPlaylistResponse.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/09.
//

import Foundation

struct FeaturedPlaylistResponse: Codable {
    let playlists: PlaylistResponse
}

struct CategoryPlaylistResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let display_name: String
    let external_urls: [String:String]
    let id: String
}

