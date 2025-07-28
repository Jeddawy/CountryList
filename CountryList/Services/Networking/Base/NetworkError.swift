//
//  NetworkError.swift
//  Ricky&Morty
//
//  Created by Ibrahim El-geddawy on 24/10/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidData
    case jsonParsingFailure
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var customDescription: String{
        switch self{
        case .invalidURL: return "Invalid URL"
        case .invalidData: return "Invalid data"
        case .jsonParsingFailure: return "You can try the search again at later time or head to the web instead."
        case let .requestFailed(description): return "Request Failed: \(description)"
        case let .invalidStatusCode(statusCode): return "Request invalid status code: \(statusCode)"
        case let .unknownError(error): return "An unknown error occured \(error.localizedDescription)"
        }
    }
}
