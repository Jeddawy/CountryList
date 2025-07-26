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

    func fetchCountries(for query: String) async {
        guard !query.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let url = URL(string: "https://restcountries.com/v2/name/\(encodedQuery)?fields=flag,name") else {
            return
        }
        print(url)
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode([CountryDetails].self, from: data) {
                self.countries = decoded.map {
                    Country(imageUrl: $0.flag ?? "", name: $0.name ?? "", capital: $0.capital ?? "", currency: $0.currencies?.first?.name ?? "")
                }
            } else {
                self.countries = []
            }
        } catch {
            print("Error fetching countries: \(error)")
            self.countries = []
        }
    }
}
