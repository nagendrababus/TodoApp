//
//  CategoryTableViewController.swift
//  TodoApp
//
//  Created by Nagendra Babu on 01/08/18.
//  Copyright © 2018 Nagendra Babu. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Mathods
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var inputTF = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
          let newCategory = Category(context: self.coreDataContext)
            newCategory.name = inputTF.text
          self.categoryArray.append(newCategory)
          self.saveCategories()
        }
        alert.addTextField { (textField) in
            inputTF = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //save the data into core data in category entity
    
    func saveCategories(){
        
        do{
            try coreDataContext.save()
        }catch{
            print("\(error) while saving the data")
        }
        
        tableView.reloadData()
    }
    
    //load the data from core data
    
    func loadCategories(){
        
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categoryArray = try coreDataContext.fetch(request)
        }catch{
            print("\(error) while getting the data")
        }
        tableView.reloadData()
    }
}
