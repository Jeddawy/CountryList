//
//  SearchCountryView.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import SwiftUI

struct SearchCountryView: View {
    @StateObject private var viewModel = SearchCountryViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter country name", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .keyboardType(.webSearch)
                    
                    Button("Search") {
                        Task {
                            await viewModel.fetchCountries(for: viewModel.searchText)
                        }
                    }
                    .disabled(viewModel.searchText.isEmpty)
                    .padding(.trailing)
                }
                .padding(.top)
                
                if viewModel.isLoading {
                    ProgressView("Searching...")
                        .padding()
                }
                
                List(viewModel.countries, id: \.name) { country in
                    NavigationLink(destination: CountryDetailsView(country: country)) {
                        CountryCardView(imageURL: country.imageUrl, title: country.name)
                            .flagCardSize(horizontalPadding: 0)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Search Country")
        }
    }
}

#Preview {
    SearchCountryView()
}
