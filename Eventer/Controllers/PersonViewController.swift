//
//  PersonViewController.swift
//  Eventer
//
//  Created by Luc Lawford on 10/06/2020.
//  Copyright © 2020 Luc Lawford. All rights reserved.
//

import UIKit
import RealmSwift

//View controller for updating the balance of a user
class PersonViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    
    let realm = try! Realm()
    
    var person: Person? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayBalance()
        
    }
    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(dismissMyKeyboard))
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
    //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
    //In short- Dismiss the active keyboard.
    view.endEditing(true)
    }
    
    func displayBalance() {
        balanceLabel.text = String(person?.balance ?? -1.0)
    }
    @IBAction func updateBtnPressed(_ sender: UIButton) {
        if let change = txtField.text {
            let changeFloat = Float(change)!
            do {
                try realm.write {
                    //Changes the balance in the database
                    person?.balance += changeFloat
                    
                    //Adds the new transaction
                    let newTran = Transaction()
                    newTran.amount = changeFloat
                    newTran.balance = person?.balance ?? 0.0
                    newTran.desc = "\(person!.name) payed £\(changeFloat) in cash"
                    newTran.date = getCurrentDate()
                    person?.transactions.append(newTran)
                    
                }
                //Updates the label
                balanceLabel.text = String(person!.balance)
            } catch {
                print(error)
            }
        } else {
            balanceLabel.text = "Enter amount to add"
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! HistoryTableViewController
        destVC.player = person
        destVC.title = person!.name + "'s History"
        
    }
    
    @IBAction func historyBtnPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToHistory", sender: self)
        
    }
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/LL/yyyy"
        return formatter.string(from: Date())
    }
}
