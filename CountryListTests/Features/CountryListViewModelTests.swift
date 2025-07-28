//
//  CountryListViewModelTests.swift
//  CountryListTests
//
//  Created by Ibrahim El-geddawy on 28/07/2025.
//

import XCTest
@testable import CountryList

@MainActor
final class CountryListViewModelTests: XCTestCase {
    
    var viewModel: CountryListViewModel!
    var mockRepository: MockCountryRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCountryRepository()
        viewModel = CountryListViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_fetchCountry_updatesDetectedCountryAndCountries() async {
        // Given
        mockRepository.shouldReturnCountries = DeveloperPreview.shared.sampleCountries
        
        // When
        await viewModel.fetchCountry(for: "Egypt")
        
        // Then
        XCTAssertEqual(viewModel.detectedCountry, "Egypt")
        XCTAssertEqual(viewModel.countries.first?.name, "Egypt") // Detected country first
    }
    
    func test_reloadCountryList_ordersCountriesCorrectly() async {
        // Given
        mockRepository.mainCountries = DeveloperPreview.shared.sampleCountries
        
        // When
        await viewModel.reloadCountryList()
        
        // Then
        XCTAssertEqual(viewModel.countries.first?.name, "Egypt")
    }
    
    func test_removeCountry_removesAndReloads() async {
        // Given
        let egypt = Country(imageUrl: "https://example.com/egypt.png",
                           name: "Egypt",
                           capital: "Cairo",
                           currency: "EGP")
        mockRepository.mainCountries = DeveloperPreview.shared.sampleCountries
        
        // When
        await viewModel.removeCountry(egypt)
        
        // Then
        XCTAssertFalse(viewModel.countries.contains(where: { $0.name == "Egypt" }))
    }
    
    
    func test_fetchCountry_handlesErrorGracefully() async {
        // Given
        mockRepository.shouldThrowError = true
        
        // When
        await viewModel.fetchCountry(for: "InvalidCountry")
        
        // Then
        XCTAssertTrue(viewModel.countries.isEmpty)
    }
}
