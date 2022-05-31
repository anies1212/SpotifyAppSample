//
//  Playlist.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String:String]
    let id:String
    let images :[APIImage]
    let name: String
    let owner: User
}
