//
//  CountryEndpoint.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import Foundation

enum CountryParameterFields: String, CodingKey, CaseIterable {
    case flags
    case name
    case currencies
    case capital
}

enum CountryEndpoint: APIEndpoint {
    
    case fetchCountry(name: String)
    case searchCountry(name: String)
    case fetchCountryDetails(name: String)


    var baseURL: URL {
        URL(string: "https://restcountries.com/v2/")!
    }
    
    var path: String {
        switch self {
        case .fetchCountry(let name):
            return "name/\(name)"
        case .searchCountry(let name):
            return "name/\(name)"
        case .fetchCountryDetails(let name):
            return "name/\(name)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCountry, .searchCountry, .fetchCountryDetails:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var parameters: [String: Any?]? {
        switch self {
        case .searchCountry:
            var items : [String: Any] = ["fields" : "\(CountryParameterFields.flags.rawValue),\(CountryParameterFields.name)"]
            return items
        case .fetchCountry:
            var items : [String: Any] = ["fields" : "\(CountryParameterFields.flags.rawValue),\(CountryParameterFields.name)"]
            return items
        case .fetchCountryDetails:
            let fields = CountryParameterFields.allCases.map { $0.rawValue }.joined(separator: ",")
            return ["fields": fields]

        }
    }
}
