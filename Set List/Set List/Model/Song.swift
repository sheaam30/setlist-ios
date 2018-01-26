//
//  File.swift
//  Set List
//
//  Created by Adam Shea on 12/9/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import Foundation

struct Song: Codable {
    
    let name: String
    let artist: String
    let genre: String
    let setList: SetList
    
    init(name: String, artist: String, genre: String, setList: SetList) {
        self.name = name
        self.artist = artist
        self.genre = genre
        self.setList = setList
    }
}
