//
//  ViewController.swift
//  Todoey
//
//  Created by Nagendra Babu on 27/07/18.
//  Copyright © 2018 Nagendra Babu. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //Plist file path
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
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
        
        //Delete the data from core data
        coreDataContext.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)

    }

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var inputTF : UITextField?
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let TFValue = inputTF?.text else {return}
            //save the data into core data
            let newItem = Item(context: self.coreDataContext)
            newItem.title = TFValue
            newItem.done = false
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
        
        do{
            //Note: Other than read that means for create,update,delete into the core data we need to call save method then only data will be effected into the core data
            //save the data into core data
            try coreDataContext.save()
        }catch{
            print("Error while using core data")
        }
        
//        let encoder = PropertyListEncoder()
//        do{
//            let demoData = try encoder.encode(self.itemArray)
//            try demoData.write(to: self.dataFilePath!)
//        }catch{
//            print("Error while encoding")
//        }
        
        self.tableView.reloadData()
    }
    
    //Decoding the data in plist Using NSCoder Protocol
    
    func loadItems(){

        // fetch the data from core data
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try coreDataContext.fetch(request)
        }catch{
            print("\(error) while fetch the data from core data")
        }
        
//        if let data = try? Data.init(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do {
//            itemArray = try decoder.decode([Item].self, from: data)
//            }catch{
//                print("Error while decoding")
//            }
//        }
    }
}

