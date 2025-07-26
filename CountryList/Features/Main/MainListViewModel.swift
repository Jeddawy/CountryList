//
//  MainListViewModel.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import Foundation

class CountryListViewModel: ObservableObject {
    @Published var countries: [Country] = [
        Country(imageUrl: "https://flagcdn.com/w320/us.png", name: "USA"),
        Country(imageUrl: "https://flagcdn.com/de.svg", name: "Germany"),
        Country(imageUrl: "https://flagcdn.com/w320/eg.png", name: "Egypt"),
        Country(imageUrl: "https://flagcdn.com/w320/fr.png", name: "France")
    ]
}
