//
//  AuthResponse.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/03.
//

import Foundation

struct AuthResponse: Codable {
    let access_token : String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type:String
}


