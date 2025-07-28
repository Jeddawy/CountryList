//
//  APIClient.swift
//  Ricky&Morty
//
//  Created by Ibrahim El-geddawy on 24/10/2024.
//

import Combine
import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: any APIEndpoint) async throws -> T
}
