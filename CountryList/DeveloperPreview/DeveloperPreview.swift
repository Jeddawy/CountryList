//
//  DeveloperPreview.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import Foundation

struct Country: Codable {
    var imageUrl: String
    var name: String
    var capital: String
    var currency: String
}

struct DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let sampleCountries: [Country] = [
        Country(imageUrl: "https://example.com/egypt.png",
                name: "Egypt",
                capital: "Cairo",
                currency: "EGP"),
        Country(imageUrl: "https://example.com/usa.png",
                name: "USA",
                capital: "Washington D.C.",
                currency: "USD"),
        Country(imageUrl: "https://example.com/canada.png",
                name: "Canada",
                capital: "Ottawa",
                currency: "CAD"),
        Country(imageUrl: "https://example.com/france.png",
                name: "France",
                capital: "Paris",
                currency: "EUR")
    ]
}
