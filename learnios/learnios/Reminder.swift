//
//  Reminder.swift
//  learnios
//
//  Created by 송승환 on 12/24/24.
//

import Foundation

class Reminder {
    var id: Int
    var title: String
    var date: Date
    
    init(id: Int, title: String, date: Date) {
        self.id = id
        self.title = title
        self.date = date
    }
}
