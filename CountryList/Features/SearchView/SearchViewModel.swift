//
//  SearchViewModel.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import Foundation

@MainActor
class SearchCountryViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    private let repository: CountryRepository
    
    init(repository: CountryRepository = CountriesRepository()) {
        self.repository = repository
    }
    
    func fetchCountries(for query: String) async {
        guard !query.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let results = try await repository.searchCountries(query: query)
            self.countries = results
        } catch {
            print("Error fetching countries: \(error)")
            self.countries = []
        }
    }
    
    //TODO: Check this and fix it
    func addToFavorites(_ country: Country) {
        if !favoriteCountries.contains(where: { $0.name == country.name }) {
            favoriteCountries.append(country)
        }
    }
    
}
