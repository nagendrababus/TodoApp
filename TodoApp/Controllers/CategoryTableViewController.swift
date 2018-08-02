//
//  CategoryTableViewController.swift
//  TodoApp
//
//  Created by Nagendra Babu on 01/08/18.
//  Copyright © 2018 Nagendra Babu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadCategories()
//       tableView.rowHeight = 80.0
    }
    
    //MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row]{
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else { fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        
        
        
        return cell
    }

    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Mathods
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var inputTF = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
          newCategory.name = inputTF.text!
          newCategory.color = UIColor.randomFlat.hexValue()
          self.saveCategories(category: newCategory)
        }
        alert.addTextField { (textField) in
            inputTF = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //save the data into realm database in category
    
    func saveCategories(category:Category){
        
        do{
           try realm.write {
                realm.add(category)
            }
        }catch{
            print("\(error) while saving the data")
        }
        
        tableView.reloadData()
    }
    
    //load the data from realm database
    
    func loadCategories(){
        
        categoryArray = realm.objects(Category.self)
    }
    
    //MARK: - Delete data from swipe
    
    override func updateDataModel(at indexPath: IndexPath) {
        
        if let categoryForDelete = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDelete)
                }
            }catch{
                print("error while deleting the object, \(error)")
            }
        }
//        tableView.reloadData()
    }
}
