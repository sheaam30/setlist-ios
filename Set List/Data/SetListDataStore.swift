//
//  SetListDataStore.swift
//  Set List
//
//  Created by Adam Shea on 12/22/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import UIKit
import CoreData

class SetListDataStore: SetListDataStoreProtocol {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let SetListKey = "listOfSetList"
    let setListMapper = SetListMapper()
    let songMapper = SongMapper()
    
    func loadSetList() -> [SetList] {
        var setListData:[SetList] = []
        
        do {
            let setListModelArray = try context.fetch(SetListModel.fetchRequest()) as! [SetListModel]
            for setListModel in setListModelArray {
                setListData.append(setListMapper.mapFromDbModel(type: setListModel))
            }
        
        } catch {
            print("Fetching Failed")
        }
        
        return setListData
      
    }

    func removeSetList(setList: SetList) {
        let setList = getSetListModel(with: setList.name!)
        context.delete(setList!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func saveSetList(_ setList: SetList) {
        let dbModel = setListMapper.mapToDbModel(model: setList)

        if (!setList.songs.isEmpty) {
            var songModels = NSSet()
            for song in setList.songs {
                songModels = songModels.adding(songMapper.mapToDbModel(model: song)) as NSSet
            }
            
            dbModel.setValue(songModels, forKey: "songs")

        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func addSong(to setList: SetList, _ song: Song) {
        do {
            let fetchRequest: NSFetchRequest = SetListModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", setList.name!)
            let setListModel = try context.fetch(fetchRequest)
        
            let songModel = SongModel(context: context)
            songModel.name = song.name
            songModel.artist = song.artist
            songModel.genre = song.genre
            
            setListModel[0].addToSongs(songModel)
        } catch {
            
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

    }
    
    func getSetList(with name: String) -> SetList? {
        let setListModel = getSetListModel(with: name)
        return setListMapper.mapFromDbModel(type: setListModel!)
    }
    
    func updateSetList(with setList: SetList) {
        let setListModel = getSetListModel(with: setList.name!)
        var songModelList: [SongModel] = []
        for song in setList.songs {
            songModelList.append(songMapper.mapToDbModel(model: song))
        }
        setListModel?.songs = NSSet(array: songModelList)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

    }
    
    private func getSetListModel(with name: String) -> SetListModel? {
        let fetchRequest: NSFetchRequest = SetListModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            
        }
        return nil
    }
}
