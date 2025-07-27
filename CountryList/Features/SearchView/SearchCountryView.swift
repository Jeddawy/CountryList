//
//  SearchCountryView.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import SwiftUI

struct SearchCountryView: View {
    @StateObject private var viewModel = SearchCountryViewModel()
    @State private var showAddConfirmation = false
    @State private var countryToAdd: Country?
    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(text: $viewModel.searchText) {
                    Task {
                        await viewModel.fetchCountries(for: viewModel.searchText)
                    }
                }
                .padding(.top)
                
                if viewModel.isLoading {
                    ProgressView("Searching...")
                        .padding()
                }
                
                List(viewModel.countries, id: \.name) { country in
                    CountryCardView(imageURL: country.imageUrl, title: country.name)
                        .flagCardSize(horizontalPadding: 0)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                countryToAdd = country
                                showAddConfirmation = true
                            } label: {
                                Label("Add", systemImage: "plus")
                            }
                            .tint(.green)
                        }
                }
                .listStyle(PlainListStyle())
                .confirmationDialog(
                    "Are you sure you want to Add this country?",
                    isPresented: $showAddConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Add", role: .none) {
                        if let country = countryToAdd {
                            Task {
                                viewModel.addToMainCountryList(country)
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
                
            }
            .navigationTitle("Search Country")
        }
    }
}

#Preview {
    SearchCountryView()
}

struct SearchBarView: View {
    @Binding var text: String
    var placeholder: String = "Search country"
    var onSearch: (() -> Void)?
    
    var body: some View {
        HStack {
            // Search Icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // Text Field
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 8)
                .disableAutocorrection(true)
                .keyboardType(.webSearch)
                .submitLabel(.search) // Show "Search" on keyboard
                .onSubmit {
                    onSearch?()
                }
            
            // Clear Button
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            
            // Search Button
            if let onSearch = onSearch {
                Button(action: onSearch) {
                    Text("Search")
                        .fontWeight(.semibold)
                }
                .disabled(text.isEmpty)
            }
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
