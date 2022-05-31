//
//  SearchResult.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/18.
//

import Foundation


enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model:Playlist)
}
