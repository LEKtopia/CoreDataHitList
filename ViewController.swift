//
//  ViewController.swift
//  CoreDataHitList
//
//  Created by Kastel, Lynette on 10/5/17.
//  Copyright © 2017 Kastel, Lynette. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // This will be the model for the table view.
    //
    // names is a mutable array that'll hold string values displayed by the table view.
    var names: [String] = []
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        
        // Guarantee the table view will return a cell of the correct
        // type when the Cell reuseIdentifier is provided to the dequed method.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
                }
            
            //self.names.append(nameToSave)
            // Pass the text field text to a new method named save()
            self.save(name: nameToSave)
            
            // Reload the rows and sections of the table view
            self.tableView.reloadData()
        }
        
        // Setup a Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // This is where CORE DATA kicks in...
    func save(name: String) {
        
        // UIApplication's shared.delegate is the delegate of the Application
        //  - make sure we have an app delegate before going on
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // The managed object context associated with the main que for core data (read-only)
        //  - get the default managed object context for the managed object that was generated
        //    by Xcode because we checked the Use Core Data checkbox. (It's a property of the 
        //    appDelgate object's persistentContainer property.
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // - Create a new managed object (based on Person entity in Data Model) called person
        // - Insert it into the managed object context.
        //
        // An entity description (NSEntityDescription) is the piece linking the entity definition
        //   form the Data Model (person) with an instance of NSManagedObject at runtime.
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
    }
}


// Add a UITableViewDataSource extension to our ViewController
//
// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    // Return the number of rows in the table as the number of items in the names array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return names.count
        return people.count
    }
    
    // Deque the table view cell based on the row index and populate the cell with the
    // corresponding string from the names array
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = people[indexPath.row]
        
        // Grab the value of the person's name attribute
        //   NSManagedObject (which person is) doesn't know about the name attribute that we defined 
        //   in our data model, so there is no way of accessing it directly via a property. 
        //   The only way Core Data provides to read the value is KVC - Key Value Coding (like a dictionary)
        // Use KVC - .value(forKey: "useExact")
        cell.textLabel?.text = person.value(forKey: "name") as? String
        
        return cell
    }
}













