//
//  SetListViewController.swift
//  Set List
//
//  Created by Adam Shea on 12/11/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import UIKit

class SetListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listOfSetLists:[SetList] = []
    var selectedRow:IndexPath?
    var dataStore:SetListDataStore = SetListDataStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SetLists"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewSetListDialog))
        self.navigationItem.rightBarButtonItem = addButton

        listOfSetLists = dataStore.loadSetList()
        tableView.reloadData()
    }
    
    @objc private func addNewSetListDialog() {
        let addDialog = UIAlertController(title: "New Set List", message: "Enter new set list name", preferredStyle: .alert)
        
        addDialog.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in self.addSetList(setListName: addDialog.textFields![0].text! )} ))
        addDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addDialog.addTextField(configurationHandler: { _ in })
    
        self.present(addDialog, animated: true, completion: nil)
    }
    
    private func addSetList(setListName: String) {
        let newItem = SetList(name: setListName)
        listOfSetLists.append(newItem)
        tableView.reloadData()
        dataStore.saveSetList(listOfSetLists: listOfSetLists)
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
        let alert = UIAlertController(title: "Delete Set List", message: "Are you sure you want to permanently delete \(setListString)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteSetList)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    private func handleDeleteSetList(alertAction: UIAlertAction!) -> Void {
        listOfSetLists.remove(at: (selectedRow?.row)!)
        tableView.deleteRows(at: [selectedRow!], with: .fade)
        dataStore.saveSetList(listOfSetLists: listOfSetLists)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setListItem") as? SetListItemViewCell
        cell?.name.text = listOfSetLists[indexPath.row].name
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
        songViewController.setList = listOfSetLists[(selectedRow?.row)!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
