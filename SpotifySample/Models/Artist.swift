//
//  Artists.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String : String]
    let images: [APIImage]?
}
