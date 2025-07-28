//
//  MockCountryRepository.swift
//  CountryListTests
//
//  Created by Ibrahim El-geddawy on 28/07/2025.
//

import XCTest
@testable import CountryList

final class MockCountryRepository: CountryRepository {
    
    var shouldReturnCountries: [Country] = []
    var mainCountries: [Country] = []
    var shouldThrowError = false
    var didAddCountry = false
    
    func fetchCountry(name: String) async throws -> [Country] {
        if shouldThrowError { throw NSError(domain: "TestError", code: -1) }
        return shouldReturnCountries
    }
    
    func getMainCountryList() async -> [Country] {
        return mainCountries
    }
    
    func removeFromMainCountryList(_ country: Country) async {
        mainCountries.removeAll { $0.name == country.name }
    }
    
    func searchCountries(query: String) async throws -> [Country] {
        if shouldThrowError { throw NSError(domain: "TestError", code: -1) }
        return shouldReturnCountries.filter { $0.name.lowercased().contains(query.lowercased()) }
    }
    
    func addToMainCountryList(_ country: Country) async {
        didAddCountry = true
        mainCountries.append(country)
    }
}
