//
//  AlbumDetailsResponse.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/14.
//

import Foundation


struct AlbumDetailsResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String:String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
    
}

struct TracksResponse: Codable {
    let items: [AudioTrack]
}
