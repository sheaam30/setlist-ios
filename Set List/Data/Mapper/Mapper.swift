//
//  Mapper.swift
//  Set List
//
//  Created by Adam Shea on 12/26/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import Foundation

protocol Mapper {
    associatedtype dbModelType
    associatedtype appModelType
    
    func mapToDbModel(model: appModelType) -> dbModelType

    func mapFromDbModel(type: dbModelType) -> appModelType
}

