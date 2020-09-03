//
//  Event.swift
//  Eventer
//
//  Created by Luc Lawford on 08/06/2020.
//  Copyright © 2020 Luc Lawford. All rights reserved.
//

import Foundation
import RealmSwift

//Stores the different events one user may have
class Event: Object {
    @objc dynamic var name: String = ""
    //Holds how much money you have in the treasurey account for that event
    @objc dynamic var cBalance: Float = 0.0
    let dates = List<EventDate>()
    let people = List<Person>()
}
