//
//  LibraryAlbumResponse.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/06/07.
//

import Foundation

struct LibraryAlbumResponse: Codable {
    let items:[SavedAlbum]
}
struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
