//
//  SettingsModels.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/03.
//

import Foundation


struct Section {
    let title : String
    let option: [Option]
}

struct Option {
    let title:String
    let handler: () -> Void
    
}
