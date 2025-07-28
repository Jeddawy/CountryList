//
//  SearchCountryViewModelTests.swift
//  CountryListTests
//
//  Created by Ibrahim El-geddawy on 28/07/2025.
//

import XCTest
@testable import CountryList

@MainActor
final class SearchCountryViewModelTests: XCTestCase {
    
    var viewModel: SearchCountryViewModel!
    var mockRepository: MockCountryRepository!
    
    override func setUp() async throws {
        mockRepository = MockCountryRepository()
        viewModel = SearchCountryViewModel(repository: mockRepository)
    }
    
    override func tearDown() async throws {
        viewModel = nil
        mockRepository = nil
    }
    
    func test_fetchCountries_updatesCountriesAndLoadingState() async {
        // Given
        mockRepository.shouldReturnCountries = DeveloperPreview.shared.sampleCountries
        
        // When
        await viewModel.fetchCountries(for: "Egypt")
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after fetch")
        XCTAssertEqual(viewModel.countries.count, 1, "Should return only countries matching query")
        XCTAssertEqual(viewModel.countries.first?.name, "Egypt")
    }
    
    func test_fetchCountries_withEmptyQuery_doesNothing() async {
        // When
        await viewModel.fetchCountries(for: "")
        
        // Then
        XCTAssertTrue(viewModel.countries.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func test_fetchCountries_handlesErrorGracefully() async {
        // Given
        mockRepository.shouldThrowError = true
        
        // When
        await viewModel.fetchCountries(for: "InvalidCountry")
        
        // Then
        XCTAssertTrue(viewModel.countries.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func test_addToMainCountryList_callsRepository() async {
        // Given
        let country = DeveloperPreview.shared.sampleCountries[0]
        
        // When
        viewModel.addToMainCountryList(country)
        try? await Task.sleep(nanoseconds: 200_000_000) // Wait for async Task
        
        // Then
        XCTAssertTrue(mockRepository.didAddCountry)
        XCTAssertTrue(mockRepository.mainCountries.contains(where: { $0.name == country.name }))
    }
}
