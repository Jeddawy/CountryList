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
    
    func getMainCountryList() async -> [Country]
    func addToMainCountryList(_ country: Country) async
    func removeFromMainCountryList(_ country: Country) async

}

class CountriesRepository: CountryRepository {
    
    private let apiClient: APIClientProtocol
    private var userDefaults: UserDefaultsServiceProtocol
    private let maxCountriesToStore = 5
    private var mainCountryList: [Country] = []
    
    
    private let MainCountryKey = "main_countries"
    
    static let shared = CountriesRepository(
           apiClient: URLSessionAPIClient<CountryEndpoint>(),
           userDefaults: UserDefaultsService.shared
       )
       
       // Internal init for DI (not private)
       init(apiClient: APIClientProtocol, userDefaults: UserDefaultsServiceProtocol) {
           self.apiClient = apiClient
           self.userDefaults = userDefaults
           self.mainCountryList = userDefaults.load(forKey: MainCountryKey, as: [Country].self) ?? []
       }
    
    //MARK: Main Country View method
    func fetchCountry(name: String) async throws -> [Country] {
        if fetchCountryLocal(name: name) != nil {
            return await getMainCountryList()
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
        let details: [CountryDetails] = try await apiClient.request(CountryEndpoint.fetchCountry(name: name))
        
        let country = Country(
            imageUrl: details.first?.flags?.png ?? "",
            name: details.first?.name ?? "",
            capital: details.first?.capital ?? "",
            currency: details.first?.currencies?.first?.name ?? ""
        )
        
        //save to storage
        await addToMainCountryList(country)
        return [country]
    }
    
    
    func searchCountries(query: String) async throws -> [Country] {
        let details: [CountryDetails] = try await apiClient.request(CountryEndpoint.searchCountry(name: query))
        
        return details.map {
            Country(
                imageUrl: $0.flags?.png ?? "",
                name: $0.name ?? "",
                capital:  $0.capital ?? "",
                currency:  $0.currencies?.first?.name ?? ""
            )
        }
    }
    
    // Local Data
    func getMainCountryList() async -> [Country] {
        return mainCountryList
    }
    
    func addToMainCountryList(_ country: Country) async {
        if !mainCountryList.contains(where: { $0.name.lowercased() == country.name.lowercased() }) {
            if mainCountryList.count >= maxCountriesToStore {
                mainCountryList.removeLast()
            }
            
            mainCountryList.append(country)
            userDefaults.save(mainCountryList, forKey: MainCountryKey)
        }
    }
    
    func removeFromMainCountryList(_ country: Country) async {
        mainCountryList.removeAll { $0.name == country.name }
        userDefaults.save(mainCountryList, forKey: MainCountryKey)
    }
}
