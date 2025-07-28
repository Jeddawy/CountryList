//
//  UserDefaultsService.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 27/07/2025.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func save<T: Codable>(_ value: T, forKey key: String)
    func load<T: Codable>(forKey key: String, as type: T.Type) -> T?
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    static let shared = UserDefaultsService()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    func save<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }
    
    func load<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return decoded
    }
}
