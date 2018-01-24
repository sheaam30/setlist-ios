//
//  ViewController.swift
//  Set List
//
//  Created by Adam Shea on 12/9/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import UIKit
import CoreData

class SongListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var setListName:String?
    var dataStore = SetListDataStore()
    var setListMapper = SetListMapper()
    var setList:SetList? = nil
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddSongDialog))
        self.navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        // Add Observer
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectChanged), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        self.title = setListName
        setList = dataStore.getSetList(with: setListName!)!
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((setList!.songs.count))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if (setList != nil) {
                setList?.songs.remove(at: indexPath.row)
                dataStore.updateSetList(with: setList!)
            }
        }
    }
    

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    @objc private func showAddSongDialog() {
        let addDialog = UIAlertController(title: "Add Song", message: "Enter new song", preferredStyle: .alert)
        
        addDialog.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "Name"
        })
        
        addDialog.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "Artist"
        })
        
        addDialog.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "Genre"
        })
        
        addDialog.addAction(UIAlertAction(title: "Add", style: .default, handler:  {
            _ in self.addSong(addDialog.textFields![0].text!,
                              addDialog.textFields![1].text!,
                              addDialog.textFields![2].text!)
            }
        ))
        
        addDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(addDialog, animated: true, completion: nil)
    }
    
    @objc private func managedObjectChanged(_ notification: Notification) {
        
        if let updates = notification.userInfo![NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            for update in updates {
                if update is SetListModel {
                    let setListModel = update  as! SetListModel
                    setList = setListMapper.mapFromDbModel(type: setListModel)
                  tableView.reloadData()
                }
            }
        }
        
        if let deletes = notification.userInfo![NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            for delete in deletes {
                print(delete)
            }
        }
    }
    
    func addSong(_ songName: String, _ songArtist: String, _ songGenre: String) {
        dataStore.addSong(to: setList!, Song(songName: songName, artist: songArtist, genre: songGenre))
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
        
        let nameText = setList?.songs[indexPath.row].name
        let artistText = setList?.songs[indexPath.row].artist
        
        cell?.boxCheckedFunction = { (selected: Bool) -> Void in
            cell?.nameLabel.strikeThrough(text: nameText!, should: selected)
            cell?.artistLabel.strikeThrough(text: artistText!, should: selected)
        }
        cell?.nameLabel.text = nameText
        cell?.artistLabel.text = artistText
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save() {
        UserDefaults.standard.set(setList, forKey: "setlist")
        UserDefaults.standard.synchronize()
    }
    
    func load() {
        if let setListData = UserDefaults.standard.value(forKey: "setlist") as? SetList        {
            setList = setListData
            tableView.reloadData()
        }
    }
}

extension UILabel {
    func strikeThrough(text: String, should strikeThrough: Bool) {
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
   
        if (strikeThrough) {
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        } else {
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
        }
        
        attributedText = attributeString
    }
}

