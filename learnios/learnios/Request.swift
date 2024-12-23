//
//  Request.swift
//  learnios
//
//  Created by 송승환 on 12/24/24.
//

import Foundation
import Alamofire

let URL: String = "http://192.168.50.83:8000"

struct ChatResponse {
    enum ResponseType {
        case reminderAdded, error, plainMessage
        func description() -> String {
            switch self {
                case .reminderAdded: return "Reminder added!"
                case .error: return "Failed handling the request."
                case .plainMessage: return ""
            }
        }
    }
    
    var responseType: ResponseType
    var message: String?
    var success: Bool
    var errorDetail: String?
    var targetReminder: Reminder?
    
    init(responseType: ResponseType, message: String? = nil, success: Bool, errorDetail: String? = nil, targetReminder: Reminder? = nil) {
        self.responseType = responseType
        self.message = message
        self.success = success
        self.errorDetail = errorDetail
        self.targetReminder = targetReminder
    }
}

struct Request {
    func fetch<T>(method: String, body: T) -> T {
        AF.request(URL, method: method, )
    }
}
