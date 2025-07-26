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
            Spacer()
        }
        .navigationTitle(country.name)
    }
}
