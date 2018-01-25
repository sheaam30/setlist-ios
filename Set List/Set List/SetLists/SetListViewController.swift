//
//  SetListViewController.swift
//  Set List
//
//  Created by Adam Shea on 12/11/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import UIKit
import CoreData

class SetListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listOfSetLists:[SetList] = []
    var selectedRow:IndexPath?
    var dataStore = SetListDataStore()
    let setListMapper = SetListMapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SetLists"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewSetListDialog))
        self.navigationItem.rightBarButtonItem = addButton

        // Add Observer
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectChanged), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    
        listOfSetLists = dataStore.loadSetList()
        tableView.reloadData()
    }
    
    @objc private func managedObjectChanged(_ notification: Notification) {
        
        if let inserts = notification.userInfo![NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            for insert in inserts {
                if (insert is SetListModel) {
                    let setListModel = insert  as! SetListModel
                    listOfSetLists.append(SetList(setListModel.name!))
                }
            }
            tableView.reloadData()
        }
        
        if let updates = notification.userInfo![NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            for update in updates {
                if (update is SetListModel) {
                    let setListModel = update as! SetListModel
                
                    if let index = listOfSetLists.index(where: { (setList) -> Bool in
                        if (setList.name == setListModel.name) {
                            return true
                        }
                        return false
                    }) {
                         listOfSetLists[index] = setListMapper.mapFromDbModel(type: setListModel)
                    }
                }
            }
            tableView.reloadData()
        }
        
        if let deletes = notification.userInfo![NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            for delete in deletes {
                print(delete)
                if (delete is SetListModel) {
                    let setListModel = delete as! SetListModel
                    let targetSetList = setListMapper.mapFromDbModel(type: setListModel)
                    if let index = listOfSetLists.index(where: { (setList) -> Bool in
                        if (setList == targetSetList) {
                            return true
                        }
                        return false
                    }) {
                        listOfSetLists.remove(at: index)
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc private func addNewSetListDialog() {
        let addDialog = UIAlertController(title: "New Set List", message: "Enter new set list name", preferredStyle: .alert)
        
        addDialog.addAction(UIAlertAction(title: "Add", style: .default, handler: {
                _ in self.addSetList(setListName: addDialog.textFields![0].text! )}
        ))
        addDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addDialog.addTextField(configurationHandler: { _ in })
    
        self.present(addDialog, animated: true, completion: nil)
    }
    
    private func addSetList(setListName: String) {
        dataStore.saveSetList(SetList(setListName))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSetLists.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            selectedRow = indexPath
            showConfirmDelete(setListString: listOfSetLists[indexPath.row].name!)
        }
    }
    
    private func showConfirmDelete(setListString:String) {
        let title = NSLocalizedString("delete_set_list_title", comment: "")
        let message = String(format: NSLocalizedString("delete_set_list_message", comment: ""), setListString)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteSetList)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    private func handleDeleteSetList(alertAction: UIAlertAction!) -> Void {
        dataStore.removeSetList(setList: listOfSetLists[(selectedRow?.row)!])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setListItem") as? SetListItemViewCell
        cell?.name.text = listOfSetLists[indexPath.row].name
        
        let format = NSLocalizedString("NumberOfMessages", comment: "")
        let message = String.localizedStringWithFormat(format, listOfSetLists[indexPath.row].songs.count)
        cell?.songCount.text = message
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath
        performSegue(withIdentifier: "songSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let songViewController:SongListViewController = segue.destination as! SongListViewController
        songViewController.setListName = listOfSetLists[(selectedRow?.row)!].name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
