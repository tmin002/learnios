//
//  Reminder.swift
//  learnios
//
//  Created by 송승환 on 12/24/24.
//

import Foundation

class Reminder: Decodable, CustomStringConvertible {
    let id: Int
    let title: String
    let date: String
    var getDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd-HHmmSS"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.date(from: self.date)!
    }
    var description: String {
        return "Reminder(id=\(self.id), title=\(self.title), date=\(self.getDate)"
    }

    static func getRemindersFromServer() async throws -> [Reminder] {
        struct Response: Decodable {
            let reminders: [Reminder]
        }
        
        let response: Response = try await Request.fetch("/get_reminders", method: .get)
        return response.reminders
    }

    static func removeReminderFromServer(reminder: Reminder) async throws -> Void {
        struct Response: Decodable {
            let removed_reminder: Reminder
        }
        
        let response: Response = try await Request.fetch("/remove_reminder?id=\(reminder.id)", method: .get)
        if response.removed_reminder.id != reminder.id {
            throw RequestError("Removed reminder's ID does not match", processable: true, cause: .client)
        }
    }

    
}
