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
        NavigationStack {
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
                .overlay(
                    LoadingOverlayView(isLoading: $viewModel.isLoading)
                )
        }
        .onAppear() {
            viewModel.fetchCountry()
        }
    }
}

#Preview {
    MainListView()
}

struct CountryListView: View {
    @ObservedObject var viewModel: CountryListViewModel
    
    @State private var showDeleteConfirmation = false
    @State private var countryToDelete: Country?
    var body: some View {
        List(viewModel.countries, id: \.name) { country in
            NavigationLink(destination: CountryDetailsView(country: country)) {
                CountryCardView(imageURL: country.imageUrl, title: country.name)
                    .flagCardSize(horizontalPadding: 0)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    countryToDelete = country
                    showDeleteConfirmation = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .onAppear {
            Task{
                await viewModel.reloadCountryList()
            }
        }
        .confirmationDialog(
            "Are you sure you want to delete this country?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let country = countryToDelete {
                    Task {
                        await viewModel.removeCountry(country)
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
