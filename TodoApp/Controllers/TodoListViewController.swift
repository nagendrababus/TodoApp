//
//  ViewController.swift
//  Todoey
//
//  Created by Nagendra Babu on 27/07/18.
//  Copyright © 2018 Nagendra Babu. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "Nagendra Babu"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "CharanTeju"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Sumanth"
//        itemArray.append(newItem3)
        
//        guard let items = defaults.array(forKey: "ToDoListArray") else {
//            return
//        }
//        itemArray = items as! [Item]
        
        loadItems()
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)

    }

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var inputTF : UITextField?
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let TFValue = inputTF?.text else {return}
            let newItem = Item()
            newItem.title = TFValue
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.saveItems()
        }
        alert.addTextField { (alertTF) in
           inputTF = alertTF
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Encoding the data in plist Using NSCoder Protocol
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        do{
            let demoData = try encoder.encode(self.itemArray)
            try demoData.write(to: self.dataFilePath!)
        }catch{
            print("Error while encoding")
        }
        self.tableView.reloadData()
    }
    
    //Decoding the data in plist Using NSCoder Protocol
    
    func loadItems(){
        
        if let data = try? Data.init(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error while decoding")
            }
        }
    }
}

