//
//  File.swift
//  Set List
//
//  Created by Adam Shea on 12/9/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import Foundation

struct Song: Codable {
    
    let song:String?
    let artist:String?
    let genre:String?
    let setList:SetList?
    
    init(songName: String, artist: String, genre: String, setList: SetList) {
        self.song = songName
        self.artist = artist
        self.genre = genre
        self.setList = setList
    }
}
