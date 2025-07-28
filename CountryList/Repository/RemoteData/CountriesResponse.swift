//
//  CountriesResponse.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import Foundation

struct CountryDetails: Decodable {
    let name: String?
    let flags: Flags?
    let capital: String?
    let currencies: [Currency]?
}

struct Flags: Decodable {
    let png: String?
}

struct Currency: Decodable {
    let name: String?
    let symbol: String?
}
