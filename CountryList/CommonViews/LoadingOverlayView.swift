//
//  LoadingOverlayView.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import SwiftUI

struct LoadingOverlayView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        ZStack {
            if isLoading {
                Color.white.opacity(0.5) // Semi-transparent background
                    .cornerRadius(10) // Optional: rounding for the popup
                ProgressView()
                    .tint(.white)
                    .scaleEffect(2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
