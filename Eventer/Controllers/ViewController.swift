//
//  ViewController.swift
//  Eventer
//
//  Created by Luc Lawford on 07/06/2020.
//  Copyright © 2020 Luc Lawford. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var events: Results<Event>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadEvents()
    }
    
    //MARK: - Database methods
    
    //Loads the events in from the database
    func loadEvents() {
        
        //Returns all the items in the events table
        events = realm.objects(Event.self)
    
        tableView.reloadData()
        
    }
    
    //Saves an event
    func saveEvents(_ event: Event) {
        do {
            try realm.write {
                realm.add(event)
            }
            tableView.reloadData()
        } catch {
            print("error")
        }
    }
    
    //Deletes an event
    override func deleteRow(at indexPath: IndexPath) {
        
        //Holds the event that needs to be deleted
        let eventToDel = self.events![indexPath.row]
        
        do {
            try self.realm.write {
                
                for date in eventToDel.dates {
                    for person in date.participants {
                        realm.delete(person)
                    }
                    realm.delete(date)
                }
                
                self.realm.delete(eventToDel)
            }
        } catch {
            print(error)
        }
    }
    
    //MARK: - TableView DataSource Methods
    
    //Sets the number of rows the table view has
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 1
    }

    //Configures each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let event = events?[indexPath.row]
        
        cell.textLabel?.text = event?.name ?? "No Events"
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDates", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! DateParticipantViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.event = events?[indexPath.row]
            destVC.title = events?[indexPath.row].name ?? "No Event"
        }
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Event", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Event", style: .default) { (action) in
            
            let newEvent = Event()
            
            newEvent.name = textField.text!
            
            self.saveEvents(newEvent)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Event"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

