//
//  SetList.swift
//  Set List
//
//  Created by Adam Shea on 12/9/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import Foundation

struct SetList: Codable, Equatable {
    
    let name: String?
    var songs:[Song]
    
    init(_ name:String = "default", _ songs:[Song] = []) {
        self.name = name
        self.songs = songs
    }
    
    
    static func ==(lhs: SetList, rhs: SetList) -> Bool {
        if lhs.name != rhs.name {
            return false
        } else {
            return true
        }
    }
    
}
