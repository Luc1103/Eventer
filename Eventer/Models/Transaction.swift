//
//  Transaction.swift
//  Eventer
//
//  Created by Luc Lawford on 04/07/2020.
//  Copyright © 2020 Luc Lawford. All rights reserved.
//

import Foundation
import RealmSwift

class Transaction: Object {
    //Amount that was updated
    @objc dynamic var amount: Float = 0.0
    //Resulting balance after the change
    @objc dynamic var balance: Float = 0.0
    @objc dynamic var desc: String = ""
    @objc dynamic var date: String = ""
    var person = LinkingObjects(fromType: Person.self, property: "transactions")
}
