//
//  CountryEndpoint.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import Foundation

enum CountryParameterFields: String, CodingKey, CaseIterable {
    case flags = "flags"
    case name = "name"
    case currencies = "currencies"
    case capital = "capital"
}

enum CountryEndpoint: APIEndpoint {
    
    case fetchCountry(name: String)
    case searchCountry(name: String)

    var baseURL: URL {
        URL(string: "https://restcountries.com/v2/")!
    }
    
    var path: String {
        switch self {
        case .fetchCountry(let name):
            return "name/\(name)"
        case .searchCountry(let name):
            return "name/\(name)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCountry, .searchCountry:
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
            let fields = CountryParameterFields.allCases.map { $0.rawValue }.joined(separator: ",")
            return ["fields": fields]
        case .fetchCountry:
            let fields = CountryParameterFields.allCases.map { $0.rawValue }.joined(separator: ",")
            return ["fields": fields]
        }
    }
}
