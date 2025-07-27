//
//  CountriesRepository.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import Foundation

protocol CountryRepository {
    func fetchCountry(name: String) async throws -> [Country]
    func searchCountries(query: String) async throws -> [Country]
    func fetchCountryDetails(name: String) async throws -> Country
    
    func getMainCountryList() -> [Country]
    func addToMainCountryList(_ country: Country)
}

class CountriesRepository: CountryRepository {
    
    private let apiClient = URLSessionAPIClient<CountryEndpoint>()
    private var userDefaults: UserDefaultsServiceProtocol
    private let maxCountriesToStore = 5
    private var mainCountryList: [Country] = []
    
    static let shared = CountriesRepository()
    
    private let MainCountryKey = "main_countries"
    
    private init(userdefaults: UserDefaultsServiceProtocol = UserDefaultsService.shared) {
        self.userDefaults = userdefaults
        self.mainCountryList = userDefaults.load(forKey: MainCountryKey, as: [Country].self) ?? []
    }
    
    
    //MARK: Main Country View method
    func fetchCountry(name: String) async throws -> [Country] {
        if let local = fetchCountryLocal(name: name) {
            return getMainCountryList()
        }
        return try await fetchCountryRemote(name: name)
    }
    
    // Local Check
    private func fetchCountryLocal(name: String) -> Country? {
        if let inMemoryCountry = mainCountryList.first(where: { $0.name.lowercased() == name.lowercased() }) {
            return inMemoryCountry
        }
        return nil
    }
    
    // Remote
    private func fetchCountryRemote(name: String) async throws -> [Country] {
        let details: [CountryDetails] = try await apiClient.request(.fetchCountry(name: name))
        
        let country = Country(
            imageUrl: details.first?.flags?.png ?? "",
            name: details.first?.name ?? "",
            capital: details.first?.capital ?? "",
            currency: ""
        )
        
        //save to storage
        addToMainCountryList(country)
        return [country]
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
    
    // Local Data
    func getMainCountryList() -> [Country] {
        return mainCountryList
    }
    
    func addToMainCountryList(_ country: Country) {
        if !mainCountryList.contains(where: { $0.name.lowercased() == country.name.lowercased() }) {
            if mainCountryList.count >= maxCountriesToStore {
                mainCountryList.removeLast()
            }
            
            mainCountryList.append(country)
            userDefaults.save(mainCountryList, forKey: MainCountryKey)
        }
    }
}
