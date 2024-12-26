//
//  Chat.swift
//  learnios
//
//  Created by 송승환 on 12/25/24.
//

import Foundation

class ChatResponse {
    enum ChatResponseType {
        case plainMessage, reminderAdded, error
    }
    var responseType: ChatResponseType
    var message: String?
    var detail: String?
    var targetReminder: Reminder?
    
    init(_ type: ChatResponseType, _ message: String? = nil, detail: String? = nil, targetReminder: Reminder? = nil) {
        self.responseType = type
        self.message = message
        self.detail = detail
        self.targetReminder = targetReminder
    }
}

class Chat {
    
    static func chat(_ text: String) async throws -> ChatResponse {
        struct Response: Decodable {
            let success: Bool
            let response: String?
            let error_detail: String?
            let target_reminder: Reminder?
            let reminder_action: String
        }
        
        do {
            let response: Response = try await Request.fetch("/chat", method: .post, parameters: ["text": text])
            if !(response.success) {
                throw RequestError(response.error_detail ?? "Unknown error",
                                   processable: false,
                                   cause: .server,
                                   fetchResponse: response)
            }
            
            switch response.reminder_action {
            case "add":
                if let reminder = response.target_reminder {
                    return ChatResponse(.reminderAdded, response.response,
                                        detail: "Reminder added:\n\(reminder.title)\n\(reminder.getDate.description)",
                                        targetReminder: reminder)
                } else {
                    throw RequestError("Response does not contain reminder information",
                                       processable: true, cause: .server)
                }
                
            case "none":
                return ChatResponse(.plainMessage, response.response)
                
            default:
                throw RequestError("Response does not contain reminder information",
                                   processable: true, cause: .server)
            }
        } catch let err as RequestError {
            if let response = err.fetchResponse as? Response {
                return ChatResponse(.error, response.response ?? "", detail: err.message)
            } else {
                return ChatResponse(.error, "Error", detail: err.message)
            }
        } catch {
           throw error
        }
    }
}
