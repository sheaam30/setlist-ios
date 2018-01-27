//
//  File.swift
//  Set List
//
//  Created by Adam Shea on 12/9/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import Foundation

struct Song: Codable, Equatable {
    
    let name:String?
    let artist:String?
    let genre:String?
    var played:Bool?
    
    init(songName: String, artist: String, genre: String, played: Bool = false) {
        self.name = songName
        self.artist = artist
        self.genre = genre
        self.played = played
    }
    
    static func ==(lhs: Song, rhs: Song) -> Bool {
        if (lhs.artist != rhs.artist &&
            lhs.name != rhs.name &&
            lhs.genre != rhs.genre &&
            lhs.played != rhs.played)  {
            return false
        }
        return true
    }
}
