//
//  Date.swift
//  Eventer
//
//  Created by Luc Lawford on 08/06/2020.
//  Copyright © 2020 Luc Lawford. All rights reserved.
//

import Foundation
import RealmSwift

//Specific instance of an event
class EventDate: Object {
    @objc dynamic var date: Int = 0
    @objc dynamic var month: Int = 0
    @objc dynamic var year: Int = 0
    let participants = List<DateParticipant>()
    var event = LinkingObjects(fromType: Event.self, property: "dates")
}
