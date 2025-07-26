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
            
            guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "https://restcountries.com/v2/name/\(encodedName)?fields=flag,capital,currencies,name") else {
                return
            }
            print(url)
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let decoded = try? JSONDecoder().decode([CountryDetails].self, from: data),
                   let first = decoded.first {
                    countryDetails = first
                    countries = [Country(imageUrl: first.flag ?? "", name: first.name ?? "", capital: first.capital ?? "", currency: first.currencies?.first?.name ?? "")]
                }
            } catch {
                print("Failed to fetch country details: \(error)")
            }
        }
    }
}

struct CountryDetails: Decodable {
    let name: String?
    let flag: String?
    let capital: String?
    let currencies: [Currency]?
}

struct Currency: Decodable {
    let code: String?
    let name: String?
    let symbol: String?
}
