//
//  SetListMapper.swift
//  Set List
//
//  Created by Adam Shea on 12/26/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import UIKit

class SetListMapper: Mapper {

    typealias dbModelType = SetListModel
    typealias appModelType = SetList
    
    var songMapper = SongMapper()
    
    func mapToDbModel(model: SetList) -> SetListModel {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let setListModel = SetListModel(context: context)
        setListModel.name = model.name

        return setListModel
    }
    
    func mapFromDbModel(type: SetListModel) -> SetList {
        var setList = SetList(type.name!)
        var songs = [Song]()
        var mysongs = type.songs
        for songModel in type.songs?.allObjects as! [SongModel] {
            songs.append(songMapper.mapFromDbModel(type: songModel))
        }

        setList.songs = songs
        return setList
    }
    
}
