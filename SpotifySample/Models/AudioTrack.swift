//
//  AudioTrack.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import Foundation


struct AudioTrack: Codable {
    var album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String:String]
    let id: String
    let name: String
    let preview_url: String?
}
