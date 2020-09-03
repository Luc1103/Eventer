//
//  DateParticipant.swift
//  Eventer
//
//  Created by Luc Lawford on 08/06/2020.
//  Copyright © 2020 Luc Lawford. All rights reserved.
//

import Foundation
import RealmSwift

//Used to store a particular instance of a person joining one event
class DateParticipant: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var date: Int = 0
    @objc dynamic var month: Int = 0
    @objc dynamic var year: Int = 0
    @objc dynamic var attending: Bool = false
    var dates = LinkingObjects(fromType: EventDate.self, property: "participants")
    var people = LinkingObjects(fromType: Person.self, property: "dates")
}
