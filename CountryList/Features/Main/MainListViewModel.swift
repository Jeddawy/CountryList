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
    @Published var detectedCountry: String = "Egypt"
    private let locationService = LocationService()
    private let repository: CountryRepository
    
    init(repository: CountryRepository = CountriesRepository.shared) {
        self.repository = repository
    }
    
    func fetchCountry() {
        Task {
            isLoading = true
            defer { isLoading = false }
            let result = await locationService.requestCountry()
            detectedCountry = result
            await fetchCountry(for: result)
        }
    }
    
    private func fetchCountry(for name: String) async {
        do {
            let results = try await repository.fetchCountry(name: name)
            orderCountryList(results)
        } catch {
            print("Error fetching countries: \(error)")
            self.countries = []
        }
    }
    
    func reloadCountryList() async {
        let countries = await repository.getMainCountryList()
        orderCountryList(countries)
    }
    
    private func orderCountryList(_ countryList: [Country]) {
        // Separate detected country and others
        let detectedFirst = countryList.filter { $0.name == detectedCountry }
        let others = countryList.filter { $0.name != detectedCountry }.sorted { $0.name < $1.name }
        
        self.countries = detectedFirst + others
    }
    
    func removeCountry(_ country: Country) async {
        await repository.removeFromMainCountryList(country)
        await reloadCountryList()
    }
}
