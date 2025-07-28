# 🌍 CountryList iOS App

A modern iOS application built with SwiftUI that allows users to discover, search, and manage a curated list of countries. The app features location-based country detection, search functionality, and persistent storage of favorite countries.

## 📱 Features

### ✨ Core Functionality
- **Location-Based Detection**: Automatically detects user's current country using Core Location
- **Smart Country Ordering**: Detected country appears first, followed by alphabetically sorted favorites
- **Persistent Storage**: Up to 5 favorite countries stored locally using UserDefaults
- **Search & Discovery**: Search countries by name using REST Countries API
- **Country Details**: View detailed information including flags, capitals, and currencies

### 🎨 User Experience
- **Swipe Actions**: Swipe to add/remove countries from favorites
- **Confirmation Dialogs**: User-friendly confirmations before actions
- **Loading States**: Elegant loading overlays during data fetching
- **Responsive Design**: Dynamic sizing that adapts to different screen sizes
- **Modern UI**: Clean, iOS-native design with proper spacing and typography

## 🏗️ Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture pattern with additional layers for better separation of concerns:

### Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                        Presentation Layer                    │
├─────────────────────────────────────────────────────────────┤
│  Views (SwiftUI)  │  ViewModels  │  Common Views            │
│  - MainListView   │  - CountryList│  - CountryCardView       │
│  - SearchView     │    ViewModel │  - LoadingOverlayView     │
│  - DetailsView    │  - SearchView│                           │
│                   │    Model     │                           │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                       Business Logic Layer                   │
├─────────────────────────────────────────────────────────────┤
│  Repository Pattern  │  Services                            │
│  - CountriesRepository│  - LocationService                  │
│  - CountryRepository │  - UserDefaultsService               │
│  (Protocol)          │  - APIClient                         │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                        Data Layer                           │
├─────────────────────────────────────────────────────────────┤
│  Remote Data  │  Local Storage  │  Models                   │
│  - REST API   │  - UserDefaults │  - Country                │
│  - Endpoints  │                 │  - CountryDetails         │
│               │                 │  - Currency               │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Getting Started

### Prerequisites

- **Xcode**: 15.0 or later
- **iOS**: 15.0 or later
- **Swift**: 5.7 or later

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/CountryList.git
   cd CountryList
   ```

2. **Open the project**
   ```bash
   open CountryList.xcodeproj
   ```

3. **Build and run**
   - Select your target device or simulator
   - Press `Cmd + R` or click the Run button
   - The app will launch and request location permissions

### Configuration

#### Location Permissions
The app requires location access to detect your current country. When prompted:
1. Tap "Allow While Using App"
2. The app will automatically detect your country and add it to the list

#### API Configuration
The app uses the [REST Countries API](https://restcountries.com/) which is free and doesn't require authentication.

## 📁 Project Structure

```
CountryList/
├── App/
│   └── CountryListApp.swift          # App entry point
├── Features/
│   ├── Main/
│   │   ├── MainListView.swift        # Main country list view
│   │   └── MainListViewModel.swift   # Main view business logic
│   ├── SearchView/
│   │   ├── SearchCountryView.swift   # Search interface
│   │   └── SearchViewModel.swift     # Search business logic
│   └── CountryDetails/
│       └── CountryDetailsView.swift  # Country detail view
├── Repository/
│   ├── CountriesRepository.swift     # Data management
│   └── RemoteData/
│       └── CountriesResponse.swift   # API response models
├── Services/
│   ├── LocationService.swift         # Location handling
│   ├── Networking/
│   │   ├── Base/
│   │   │   ├── APIClient.swift       # Generic API client
│   │   │   ├── EndPoint.swift        # Endpoint protocol
│   │   │   ├── NetworkError.swift    # Network error types
│   │   │   └── URLSessionAPIClient.swift
│   │   └── Endpoints/
│   │       └── CountryEndpoint.swift # API endpoints
│   └── UserDefaultsService.swift     # Local storage
├── CommonViews/
│   ├── CountryCardView.swift         # Reusable country card
│   └── LoadingOverlayView.swift      # Loading state component
├── DeveloperPreview/
│   └── DeveloperPreview.swift        # Preview data models
└── Resources/
    └── Assets.xcassets/              # App assets
```

## 📁 Archtecture Diagram

<img width="589" height="412" alt="Diagram" src="https://github.com/user-attachments/assets/440d78c4-e7b4-4871-8023-9feda2060b50" />

## 🧪 Testing

The project includes comprehensive test coverage:

```bash
# Run all tests
Cmd + U

# Run specific test target
# Select test target in Xcode and run
```

### Test Structure
- **Unit Tests**: Business logic and data layer testing
- **Repository Tests**: Data management testing
- **Mock Objects**: Test doubles for isolated testing

## 🔧 Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming for data binding
- **Core Location**: Location services and geocoding
- **URLSession**: Network requests and API communication
- **UserDefaults**: Local data persistence
- **REST Countries API**: Country data source

## 📱 Demo
![Demo](https://github.com/user-attachments/assets/e1b4f8ff-1cd7-47ee-88d2-bf95da8e063b)



---

**Note**: This app requires location permissions to function properly. The app will default to "Egypt" if location access is denied. 
