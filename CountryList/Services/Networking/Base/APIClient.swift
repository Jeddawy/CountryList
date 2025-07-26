//
//  APIClient.swift
//  Ricky&Morty
//
//  Created by Ibrahim El-geddawy on 24/10/2024.
//

import Combine
import Foundation

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T
}
