//
//  CountryCardView.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import SwiftUI

// MARK: - Flag Card Component
struct CountryCardView: View {
    let imageURL: String
    let title: String
    var cornerRadius: CGFloat = 12
    
    var body: some View {
        ZStack {
            FlagImageView(imageURL: imageURL)
                .flagCardSize(horizontalPadding: 0)

            FlagOverlayView()
            
            FlagTitleView(title: title)
        }
        .clipped()
        .cornerRadius(cornerRadius)
    }
}

#Preview {
    CountryCardView(
        imageURL: "https://flagcdn.com/w320/us.png",
        title: "United States of America"
    )
    .flagCardSize(horizontalPadding: 10)
}

// MARK: - Flag Image Component
private struct FlagImageView: View {
    let imageURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                Color.gray.opacity(0.2)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Color.red.opacity(0.2)
            @unknown default:
                Color.gray.opacity(0.2)
            }
        }
    }
}

// MARK: - Overlay Component
private struct FlagOverlayView: View {
    var body: some View {
        Color.black.opacity(0.1)
    }
}

// MARK: - Title Component
private struct FlagTitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.horizontal, 8)
            .multilineTextAlignment(.center)
    }
}

// MARK: - FlagCardSizeModifier
struct FlagCardSizeModifier: ViewModifier {
    let horizontalPadding: CGFloat
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - (horizontalPadding * 2)
            let cardHeight = availableWidth * 0.7
            
            content
                .frame(width: availableWidth, height: cardHeight)
                .padding(.horizontal, horizontalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: calculateHeight()) // Key fix: explicit height for the GeometryReader
    }
    
    // Calculate expected height based on screen width
    private func calculateHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let availableWidth = screenWidth - (horizontalPadding * 2)
        let cardHeight = availableWidth * (2 / 3)
        return cardHeight
    }
}

// MARK: - View Extension for Easy Use
extension View {
    func flagCardSize(horizontalPadding: CGFloat = 10) -> some View {
        self.modifier(FlagCardSizeModifier(horizontalPadding: horizontalPadding))
    }
}
