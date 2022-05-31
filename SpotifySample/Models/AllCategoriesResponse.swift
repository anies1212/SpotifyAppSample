//
//  AllCategoriesResponse.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/14.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}
