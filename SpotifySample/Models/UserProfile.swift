//
//  UserProfile.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import Foundation


struct UserProfile: Codable{
    let country: String
    let display_name: String
    let email:String
    let explicit_content: [String:Bool]
    let external_urls:[String:String]
//    let followers: [String:Codable?]
    let id: String
    let images: [UserImage]
    let product: String
}

struct UserImage: Codable {
    let url: String
}

