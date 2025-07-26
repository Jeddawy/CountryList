//
//  CountriesRepository.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import Foundation

protocol CountryRepository {
    func fetchCountry(name: String) async throws -> Country
    func searchCountries(query: String) async throws -> [Country]
    func fetchCountryDetails(name: String) async throws -> Country
}

class CountriesRepository: CountryRepository {
    
    private let apiClient = URLSessionAPIClient<CountryEndpoint>()
    
    func fetchCountry(name: String) async throws -> Country {
        let details: [CountryDetails] = try await apiClient.request(.fetchCountry(name: name))
        
        return Country(
            imageUrl: details.first?.flags?.png ?? "",
            name: details.first?.name ?? "",
            capital: details.first?.capital ?? "",
            currency: ""
        )
    }
    
    func searchCountries(query: String) async throws -> [Country] {
        let details: [CountryDetails] = try await apiClient.request(.searchCountry(name: query))
        
        return details.map {
            Country(
                imageUrl: $0.flags?.png ?? "",
                name: $0.name ?? "",
                capital:  "",
                currency:  ""
            )
        }
    }
    
    func fetchCountryDetails(name: String) async throws -> Country {
        let details: [CountryDetails] = try await apiClient.request(.fetchCountryDetails(name: name))
        
        return Country(
            imageUrl: details.first?.flags?.png ?? "",
            name: details.first?.name ?? "",
            capital: details.first?.capital ?? "",
            currency: details.first?.currencies?.first?.name ?? ""
        )
    }
}
