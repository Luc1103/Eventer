//
//  DateParticipantViewController.swift
//  Eventer
//
//  Created by Luc Lawford on 10/06/2020.
//  Copyright © 2020 Luc Lawford. All rights reserved.
//


//ADD ALL THE CODE FOR THE CENTRE TABLE VIEW OPTION


import UIKit
import RealmSwift

//Enum for what to put in the table view
enum tVContents {
    case showDates
    case showCentre
    case showPlayers
}

class DateParticipantViewController: SwipeTableViewController {
    
    @IBOutlet weak var datesBtn: UIButton!
    @IBOutlet weak var playersBtn: UIButton!
    
    let realm = try! Realm()
    
    var dates: List<EventDate>?
    var people: List<Person>?
    
    var event: Event? {
        didSet {
            loadItems()
        }
    }
    
    var contents: tVContents = .showDates

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    //MARK: - Database Methods
    
    //Loads the events in from the database
    func loadItems() {

        dates = event!.dates
        people = event!.people
    
        tableView.reloadData()
        
    }
    
    //Saves an event
    func saveItems(_ item: Object) {
        do {
            try realm.write {
                realm.add(item)
            }
            tableView.reloadData()
        } catch {
            print("error")
        }
    }
    
    //Deletes row
    override func deleteRow(at indexPath: IndexPath) {
        
        switch contents {
            
        case .showDates:
            deleteDate(at: indexPath)
            
        case .showCentre:
            print("f")
            
        case .showPlayers:
            deletePlayer(at: indexPath)
        }

    }
    
    //For deleting a date
    func deleteDate(at indexPath: IndexPath) {
        
        //Represents the date to be deleted
        if let dateToDel = dates?[indexPath.row] {
        
            do {
                try realm.write {
                    if let sEvent = event {
                        for person in sEvent.people {
                            for date in person.dates {
                                if date.date == dateToDel.date &&
                                    date.month == dateToDel.month &&
                                    date.year == dateToDel.year {
                                    realm.delete(date)

                                }
                            }
                        }
                    }
                    realm.delete(dateToDel)
                }
            } catch {
                print(error)
            }
        } else {
            print("no dates")
        }
    }
    
    //For deleting a player
    func deletePlayer(at indexPath: IndexPath) {
        
        //Represents the person to be deleted
        if let personToDel = people?[indexPath.row] {
        
            do {
                try realm.write {
                    if let sEvent = event {
                        for date in sEvent.dates {
                            for person in date.participants {
                                
                                if person.name == personToDel.name {
                                    realm.delete(person)
                                }
                            }
                        }
                    }
                    realm.delete(personToDel)
                }
            } catch {
                print(error)
            }
        } else {
            print("no dates")
        }
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch contents {
            
        case .showDates:
            return dates?.count ?? 1
        case .showCentre:
            return dates?.count ?? 1
        case .showPlayers:
            return people?.count ?? 1
        }
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        switch contents {
            
        case .showDates:
            if let date = dates?[indexPath.row] {
                
                let dateString = String(date.date) + "/" + String(date.month) + "/" + String(date.year)
                
                cell.textLabel?.text = dateString
            } else {
                cell.textLabel?.text = "No Dates Added"
            }
        case .showCentre:
            print("add code")
        case .showPlayers:
            if let person = people?[indexPath.row] {
                cell.textLabel?.text = person.name + " " + String(person.balance)
            } else {
                cell.textLabel?.text = "No People Added"
            }
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch contents {
            
        case .showDates:
            performSegue(withIdentifier: "goToDate", sender: self)
        case .showCentre:
            print("add code")
        case .showPlayers:
            performSegue(withIdentifier: "goToPerson", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch contents {
        case .showDates:
            let destVC = segue.destination as! DateTableViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destVC.date = dates![indexPath.row]
                destVC.title = tableView(tableView, cellForRowAt: indexPath).textLabel?.text
            }
        case .showCentre:
            print("add code")
        case .showPlayers:
            let destVC = segue.destination as! PersonViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destVC.person = people![indexPath.row]
                destVC.title = people![indexPath.row].name
            }
        }
    
    }
    
    //MARK: - Switch View Methods
    
    @IBAction func datesBtnPressed(_ sender: UIButton) {
        
        if contents != .showDates {
            contents = .showDates
            
            loadItems()
        }

        
    }
    
    @IBAction func playersBtnPressed(_ sender: UIButton) {
        
        if contents != .showPlayers {
            contents = .showPlayers
            
            loadItems()
        }
        
    }
    
    
    @IBAction func centreBtnPressed(_ sender: UIButton) {
        
        if contents != .showCentre {
            contents = .showCentre
            
            loadItems()
        }
        
    }
    
    
    //MARK: - Add Date or Person Method
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        switch contents {
        
        case .showDates:
            addDate()
        case .showCentre:
            print("add person")
        case .showPlayers:
            addPerson()
        }
        
    }
    
    func addDate() {
        var dateTxtField = UITextField()
        var monthTxtField = UITextField()
        var yearTxtField = UITextField()
        
        let alert = UIAlertController(title: "Add New Date", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Date", style: .default) { (action) in

            if let currentEvent = self.event {
                do {
                    try self.realm.write {
                        //Adds the date to the database
                        let newDate = EventDate()
                        newDate.date = Int(dateTxtField.text!)!
                        newDate.month = Int(monthTxtField.text!)!
                        newDate.year = Int(yearTxtField.text!)!
                        currentEvent.dates.append(newDate)
                        
                        //Adds the instances of people attending
                        if let safePeople = self.people {
                            for person in safePeople {
                                //Variable to store the new participant instance
                                let newPart = DateParticipant()
                                newPart.name = person.name
                                newPart.date = newDate.date
                                newPart.month = newDate.month
                                newPart.year = newDate.year
                                //Adds the link to the dates and person classes
                                //This connects everyone as a participant and the 'attending'
                                //property determines if they are attending the event on that date
                                newDate.participants.append(newPart)
                                person.dates.append(newPart)
                            }
                        }
                        
                    }
                } catch {
                    print(error)
                }
            } else {
                print("no event collected")
            }
            
            self.tableView.reloadData()
        
        }

        alert.addTextField { (dateAlertTxtField) in
            dateAlertTxtField.placeholder = "Add the date"
            dateTxtField = dateAlertTxtField //Allows the text field to be accessed outside of the closure
        }
        
        alert.addTextField { (monthAlertTxtField) in
            monthAlertTxtField.placeholder = "Add the month"
            monthTxtField = monthAlertTxtField //Allows the text field to be accessed outside of the closure
        }
        
        alert.addTextField { (yearAlertTxtField) in
            yearAlertTxtField.placeholder = "Add the year"
            yearTxtField = yearAlertTxtField //Allows the text field to be accessed outside of the closure
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
    }
    
    func addPerson() {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new person", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Person", style: .default) { (action) in

            if let currentEvent = self.event {
                do {
                    try self.realm.write {
                        let newPerson = Person()
                        newPerson.name = textField.text!
                        currentEvent.people.append(newPerson)
                        
                        //Adds the person as a participant on each date
                        //Adds the instances of people attending
                        if let safeDates = self.dates {
                            for date in safeDates {
                                //Variable to store the new participant instance
                                let newPart = DateParticipant()
                                newPart.name = newPerson.name
                                newPart.date = date.date
                                newPart.month = date.month
                                newPart.year = date.year
                                //Adds the link to the dates and person classes
                                //This connects everyone as a participant and the 'attending'
                                //property determines if they are attending the event on that date
                                date.participants.append(newPart)
                                newPerson.dates.append(newPart)
                            }
                        }
                        
                    }
                } catch {
                    print(error)
                }
            } else {
                print("no category collected")
            }
            
            self.tableView.reloadData()

        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Person"
            textField = alertTextField //Allows the text field to be accessed outside of the closure
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
    
}
