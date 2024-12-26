//
//  Request.swift
//  learnios
//
//  Created by 송승환 on 12/24/24.
//

import Foundation
import Alamofire

let BASE_URL: String = "http://tmincloud.asuscomm.com:8889"

struct RequestError: Error {
    enum RequestErrorCause {
        case unknown, server, client
        var description: String {
            switch self {
            case .unknown: return "Request failed due to unknown error"
            case .server: return "Request failed due to server error"
            case .client: return "Request failed due to client error"
            }
        }
    }
    
    let message: String
    let processable: Bool
    let cause: RequestErrorCause
    let fetchResponse: Any?
    
    init(_ message: String? = "", processable: Bool, cause: RequestErrorCause, fetchResponse: Any? = nil) {
        self.message = message ?? cause.description
        self.processable = processable
        self.cause = cause
        self.fetchResponse = fetchResponse
    }
}

class Request {

    static func fetch<ResponseType: Decodable>(_ location: String = "",
               method: HTTPMethod = .post,
               parameters: [String: Any] = [:]
    ) async throws -> ResponseType {
        
        let url = BASE_URL + location
        let parameters = (method != .get) ? parameters : nil
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default
            )
            .responseDecodable(of: ResponseType.self) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                    
                case .failure(let error):
                    let statusCode: Int = response.response?.statusCode ?? 0
                    
                    if statusCode == 0 {
                        continuation.resume(throwing: error)
                        return
                    }
                    if !(200...299).contains(statusCode) {
                        continuation.resume(throwing: RequestError(
                            "Server responded with status code \(statusCode)",
                            processable: false,
                            cause: .server
                        ))
                        return
                    }
                    
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
