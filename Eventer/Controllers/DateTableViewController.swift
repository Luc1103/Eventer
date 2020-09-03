//
//  DateTableViewController.swift
//  Eventer
//
//  Created by Luc Lawford on 10/06/2020.
//  Copyright © 2020 Luc Lawford. All rights reserved.
//

import UIKit
import RealmSwift

//View controller for showing attendees on a particular date
class DateTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var people: List<DateParticipant>?
    
    var date: EventDate? {
        didSet {
            loadPeople()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets the height of each row
        tableView.rowHeight = 80
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let person = people?[indexPath.row] {
            
            cell.textLabel?.text = person.name
            cell.accessoryType = person.attending ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No people"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let person = people?[indexPath.row] {
            
            do {
                try realm.write {
                    
                    //Sets up the new transaction
                    let newTran = Transaction()
                    
                    if person.attending {
                        person.attending = false
                        person.people[0].balance += 5
                        
                        newTran.balance = person.people[0].balance
                        newTran.amount = 5.0
                        
                        newTran.desc = "\(person.name) is no longer attending a game"
                        
                    } else {
                        person.attending = true
                        person.people[0].balance -= 5
                        
                        newTran.balance = person.people[0].balance
                        newTran.amount = -5.0
                        
                        newTran.desc = "\(person.name) is attending a game"
                    }
                    
                    newTran.date = String(date!.date) + "/"
                    newTran.date.append(String(date!.month) + "/")
                    newTran.date.append(String(date!.year))
                    
                    //Adds the new transaction to the database
                    person.people[0].transactions.append(newTran)
                }
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
        
    }

    //MARK: - Database Methods
    
    func loadPeople() {
        people = date?.participants ?? nil
        tableView.reloadData()
    }
    
}
