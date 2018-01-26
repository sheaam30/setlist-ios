//
//  SetlistStoring.swift
//  Set List
//
//  Created by Adam Shea on 12/22/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import UIKit

protocol SetListStoring {
    
    func saveSetList(listOfSetLists: [SetList])
    
    func loadSetList() -> [SetList]
}
