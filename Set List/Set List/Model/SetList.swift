//
//  SetList.swift
//  Set List
//
//  Created by Adam Shea on 12/9/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import Foundation

struct SetList: Codable {
    
    let name: String?
    var songs:[Song] = []
    
    init(name:String = "default") {
        self.name = name
    }
}
