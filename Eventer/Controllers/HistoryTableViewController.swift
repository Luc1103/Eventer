//
//  HistoryTableViewController.swift
//  Eventer
//
//  Created by Luc Lawford on 03/07/2020.
//  Copyright © 2020 Luc Lawford. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var player: Person? {
        didSet {
            loadItems()
        }
    }
    
    var transacs: List<Transaction>?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transacs?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let transac = transacs?[indexPath.row] {
            
            cell.textLabel?.numberOfLines = 0
    
            cell.textLabel?.text = "\(transac.desc)" +
                                    "\nAmount changed: " + String(transac.amount) +
                                    "\nResulting Balance: " + String(transac.balance) +
                                    "\n\(transac.date)"
            
            
            
        } else {
            cell.textLabel?.text = "no transaction"
        }
        
        
        return cell
    }
    
    func loadItems() {
        transacs = player!.transactions
        tableView.reloadData()
    }
    
    override func deleteRow(at indexPath: IndexPath) {
        do {
            try realm.write() {
                realm.delete(transacs![indexPath.row])
            }
        } catch {
            print(error)
        }
    }

}
