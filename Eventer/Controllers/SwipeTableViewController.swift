//
//  SwipeTableViewController.swift
//  Eventer
//
//  Created by Luc Lawford on 10/06/2020.
//  Copyright © 2020 Luc Lawford. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets the height of each row
        tableView.rowHeight = 80
        
        //Removes the seperator between lines
//        tableView.separatorStyle = .none
        

    }

    // MARK: - Table view data source

    //Dequeues the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Creates the cell and downcasts it to a swipe cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell

        cell.delegate = self //Sets the delegate to self

        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteRow(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        //Allows the cell to be fully swiped to delete it
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteRow(at indexPath: IndexPath) {
        
    }


}
