//
//  ViewController.swift
//  Todoey
//
//  Created by Nagendra Babu on 27/07/18.
//  Copyright © 2018 Nagendra Babu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBarDemo: UISearchBar!
    
    var toDoItems:Results<Item>?

    var selectedCategory:Category? {
        didSet{
            loadItems()
        }
    }
    
    let realm = try! Realm()
    
    //Plist file path
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       searchBarDemo.delegate = self
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //loadItems()
        
        //Static Items
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.color else { fatalError() }
            
        updateNavBar(withHexCode: colorHex)
    }
    
   override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: - Navbar set up methods
    
    func updateNavBar(withHexCode colorHexCode:String){
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist")
        }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:ContrastColorOf(navBarColor, returnFlat: true)]
        searchBarDemo.barTintColor = navBarColor
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row)/CGFloat(toDoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    //To delete the object in realm database
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        
        //Delete the data from core data
//        coreDataContext.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //saveItems()

        tableView.deselectRow(at: indexPath, animated: true)

    }

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var inputTF : UITextField?
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let TFValue = inputTF?.text else {return}
            //save the data into Realm Database
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = TFValue
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("\(error) while inserting the data into realm database")
                }
                
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTF) in
           inputTF = alertTF
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Encoding the data in plist Using NSCoder Protocol
//    func saveItems(){
//
//        do{
//            //Note: Other than read that means for create,update,delete into the core data we need to call save method then only data will be effected into the core data
//            //save the data into core data
//            try coreDataContext.save()
//        }catch{
//            print("Error while using core data")
//        }
//
////        let encoder = PropertyListEncoder()
////        do{
////            let demoData = try encoder.encode(self.itemArray)
////            try demoData.write(to: self.dataFilePath!)
////        }catch{
////            print("Error while encoding")
////        }
//
//        self.tableView.reloadData()
//    }
    
    //Decoding the data in plist Using NSCoder Protocol
    
//    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil){
//
//        // fetch the data from core data
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
////
////        request.predicate = compoundPredicate
//
//        do{
//            itemArray = try coreDataContext.fetch(request)
//        }catch{
//            print("\(error) while fetch the data from core data")
//        }
//
//        tableView.reloadData()
//
////        if let data = try? Data.init(contentsOf: dataFilePath!){
////            let decoder = PropertyListDecoder()
////            do {
////            itemArray = try decoder.decode([Item].self, from: data)
////            }catch{
////                print("Error while decoding")
////            }
////        }
//    }
    
    
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateDataModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.toDoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print("Error while deleting the data, \(error)")
            }
        }
    }
    
}

//MARK: - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

        //Fetch the data from core data using NSPredicator
//        let request:NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request,predicate:predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

