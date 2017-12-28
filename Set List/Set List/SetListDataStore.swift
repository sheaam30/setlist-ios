//
//  SetListDataStore.swift
//  Set List
//
//  Created by Adam Shea on 12/22/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import UIKit

class SetListDataStore: SetListDataStoreProtocol {
    
    let SetListKey = "listOfSetList"
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func loadSetList() -> [SetList] {
        var setListData:[SetList] = []
        if let data = UserDefaults.standard.data(forKey: SetListKey) {
        
            if let listData = try? decoder.decode([SetList].self, from: data)
            {
                setListData = listData
            }
        }
        return setListData
    }
    
    func saveSetList(listOfSetLists: [SetList]) {
        if let encoded = try? encoder.encode(listOfSetLists) {
            UserDefaults.standard.set(encoded, forKey: SetListKey)
            UserDefaults.standard.synchronize()
        }
    }
}
