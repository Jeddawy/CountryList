//
//  MainListView.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//


import SwiftUI

// MARK: - Main View
struct MainListView: View {
    @StateObject private var viewModel = CountryListViewModel()
    
    var body: some View {
        NavigationView {
            CountryListView(viewModel: viewModel)
                .listStyle(.plain)
                .navigationTitle("Country List")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SearchCountryView()) {
                            Image(systemName: "magnifyingglass")
                                .tint(.gray)
                        }
                    }
                }
        }
        
    }
}

#Preview {
    MainListView()
}

private struct CountryListView: View {
    @ObservedObject var viewModel: CountryListViewModel
    
    var body: some View {
        List(viewModel.countries, id: \.name) { country in
            NavigationLink(destination: CountryDetailsView(country: country)) {
                CountryCardView(imageURL: country.imageUrl, title: country.name)
                    .flagCardSize(horizontalPadding: 0)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
    }
}
