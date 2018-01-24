//
//  SetlistDataStore.swift
//  Set List
//
//  Created by Adam Shea on 12/22/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import UIKit

protocol SetListDataStoreProtocol {
        
    func saveSetList(_ listOfSetLists:SetList)

    func loadSetList() -> [SetList]
    
    func addSong(to setList : SetList, _ song: Song)
    
    func getSetList(with name:String) -> SetList?
    
    func removeSetList(setList: SetList)
    
    func updateSetList(with setList: SetList)
}
