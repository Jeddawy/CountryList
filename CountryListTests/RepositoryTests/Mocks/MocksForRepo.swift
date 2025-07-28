//
//  MocksForRepo.swift
//  CountryListTests
//
//  Created by Ibrahim El-geddawy on 27/07/2025.
//

import XCTest
import Foundation
@testable import CountryList

// MARK: - Mock Classes
final class MockAPIClient: APIClientProtocol {
    var shouldReturn: Any?
    var shouldThrowError = false
    var requestCalled = false
    
    func request<T>(_ endpoint: any APIEndpoint) async throws -> T where T: Decodable {
        requestCalled = true
        if shouldThrowError { throw NSError(domain: "TestError", code: -1) }
        return shouldReturn as! T
    }
}

final class MockUserDefaultsService: UserDefaultsServiceProtocol {
    var storage: [String: Any] = [:]
    var saveCalled = false
    
    func save<T>(_ object: T, forKey key: String) where T : Encodable {
        storage[key] = object
        saveCalled = true
    }
    
    func load<T>(forKey key: String, as type: T.Type) -> T? where T : Decodable {
        return storage[key] as? T
    }
}
