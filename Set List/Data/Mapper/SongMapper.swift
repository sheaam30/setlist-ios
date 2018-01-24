//
//  SongMapper.swift
//  Set List
//
//  Created by Adam Shea on 12/26/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import Foundation
import UIKit

class SongMapper: Mapper {

    typealias dbModelType = SongModel
    
    typealias appModelType = Song
    
    func mapToDbModel(model: Song) -> SongModel {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let songModel = SongModel(context: context)
        songModel.name = model.name
        songModel.artist = model.artist
        songModel.genre = model.genre
        return songModel
    }
    
    func mapFromDbModel(type: SongModel) -> Song {
        var song = Song(songName: type.name!, artist: type.artist!, genre: type.genre!)
        return song
    }
    
}
