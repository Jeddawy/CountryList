//
//  MainListViewModel.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import Foundation

@MainActor
class CountryListViewModel: ObservableObject {
    @Published var countries: [Country] = []
    
    @Published var countryDetails: CountryDetails? = nil
    @Published var isLoading = false
    @Published var country: String = "Egypt"
    private let locationService = LocationService()
    private let repository: CountryRepository
    
    init(repository: CountryRepository = CountriesRepository()) {
        self.repository = repository
    }

    
    func fetchCountry() {
        Task {
            let result = await locationService.requestCountry()
            country = result
            await fetchCountryDetails(for: result)
        }
    }
    
    private func fetchCountryDetails(for name: String) async {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let results = try await repository.fetchCountry(name: name)
                self.countries = [results]
            } catch {
                print("Error fetching countries: \(error)")
                self.countries = []
            }
        }
    }
}
