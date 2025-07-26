//
//  CountryDetailsView.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import SwiftUI

// MARK: - Detail View
struct CountryDetailsView: View {
    let country: Country
    
    var body: some View {
        VStack {
            CountryCardView(imageURL: country.imageUrl, title: country.name)
                .flagCardSize()
            Text(country.capital)
            Text(country.currency)
            Spacer()
        }
        .padding(10)
        .navigationTitle(country.name)
    }
}
