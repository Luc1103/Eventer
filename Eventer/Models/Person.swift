//
//  Person.swift
//  Eventer
//
//  Created by Luc Lawford on 08/06/2020.
//  Copyright © 2020 Luc Lawford. All rights reserved.
//

import Foundation
import RealmSwift

class Person: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var balance: Float = 0.0
    let dates = List<DateParticipant>()
    let transactions = List<Transaction>()
    var event = LinkingObjects(fromType: Event.self, property: "people")
}
