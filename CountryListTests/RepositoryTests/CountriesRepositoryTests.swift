//
//  CountriesRepositoryTests.swift
//  CountryListTests
//
//  Created by Ibrahim El-geddawy on 28/07/2025.
//

import XCTest
@testable import CountryList

final class CountriesRepositoryTests: XCTestCase {
    
    var repository: CountriesRepository!
    var mockAPIClient: MockAPIClient!
    var mockUserDefaults: MockUserDefaultsService!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        mockUserDefaults = MockUserDefaultsService()
        repository = CountriesRepository(apiClient: mockAPIClient, userDefaults: mockUserDefaults)
    }
    
    override func tearDown() {
        repository = nil
        mockAPIClient = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    func test_fetchCountry_returnsLocalCountry() async throws {
        // Given
        let localCountry = Country(imageUrl: "", name: "Egypt", capital: "Cairo", currency: "EGP")
        await repository.addToMainCountryList(localCountry)
        
        // When
        let result = try await repository.fetchCountry(name: "Egypt")
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Egypt")
        XCTAssertEqual(mockAPIClient.requestCalled, false)
    }
    
    func test_fetchCountry_callsAPIWhenNotInLocal() async throws {
        // Given
        let details = CountryDetails(name: "Egypt", flags: Flags(png: "flag.png"), capital: "Cairo", currencies: [Currency(name: "EGP", symbol: "")])
        mockAPIClient.shouldReturn = [details]
        
        // When
        let result = try await repository.fetchCountry(name: "Egypt")
        
        // Then
        XCTAssertEqual(result.first?.name, "Egypt")
        XCTAssertTrue(mockAPIClient.requestCalled)
    }
    
    func test_fetchCountry_throwsErrorOnAPIFailure() async {
        // Given
        mockAPIClient.shouldThrowError = true
        
        // When/Then
        do {
            _ = try await repository.fetchCountry(name: "Egypt")
            XCTFail("Expected error, but got success")
        } catch {
            XCTAssertTrue(mockAPIClient.requestCalled)
        }
    }
    
    func test_searchCountries_returnsResults() async throws {
        // Given
        let details = CountryDetails(name: "France", flags: Flags(png: "flag.png"), capital: "Paris", currencies: [Currency(name: "EUR", symbol: "")])
        mockAPIClient.shouldReturn = [details]
        
        // When
        let result = try await repository.searchCountries(query: "France")
        
        // Then
        XCTAssertEqual(result.first?.name, "France")
    }
    
    func test_addToMainCountryList_addsAndPersists() async {
        // Given
        let country = Country(imageUrl: "", name: "Egypt", capital: "Cairo", currency: "EGP")
        
        // When
        await repository.addToMainCountryList(country)
        
        // Then
        let stored = await repository.getMainCountryList()
        XCTAssertTrue(stored.contains(where: { $0.name == "Egypt" }))
        XCTAssertTrue(mockUserDefaults.saveCalled)
    }
    
    func test_removeFromMainCountryList_removesAndPersists() async {
        // Given
        let country = Country(imageUrl: "", name: "Egypt", capital: "Cairo", currency: "EGP")
        await repository.addToMainCountryList(country)
        
        // When
        await repository.removeFromMainCountryList(country)
        
        // Then
        let stored = await repository.getMainCountryList()
        XCTAssertFalse(stored.contains(where: { $0.name == "Egypt" }))
    }
}
