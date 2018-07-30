//
//  ViewController.swift
//  Todoey
//
//  Created by Nagendra Babu on 27/07/18.
//  Copyright © 2018 Nagendra Babu. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Nagendra Babu","Charan Teja","Santosh"]
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let items = defaults.value(forKey: "ToDoListArray") else {
            return
        }
        itemArray = items as! [String]
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var inputTF : UITextField?
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let TFValue = inputTF?.text else {return}
            self.itemArray.append(TFValue)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTF) in
           inputTF = alertTF
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

