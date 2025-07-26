//
//  LocationService.swift
//  CountryList
//
//  Created by Ibrahim El-geddawy on 26/07/2025.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation?, Never>?
    private var authContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestCountry() async -> String {
        let status = manager.authorizationStatus
        
        // If not determined, request permission and wait for response
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
            let newStatus = await withCheckedContinuation { continuation in
                self.authContinuation = continuation
            }
            
            // If permission wasn't granted, return Egypt
            if newStatus != .authorizedWhenInUse && newStatus != .authorizedAlways {
                return "Egypt"
            }
        } else if status != .authorizedWhenInUse && status != .authorizedAlways {
            // If already denied, restricted, or any other non-authorized status
            return "Egypt"
        }
        
        // Request location
        manager.requestLocation()
        
        // Wait for location or timeout
        let location = await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
        }
        
        return await reverseGeocode(location)
    }

    private func reverseGeocode(_ location: CLLocation?) async -> String {
        guard let location = location else { return "Egypt" }
        
        return await withCheckedContinuation { continuation in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let country = placemarks?.first?.country {
                    continuation.resume(returning: country)
                } else {
                    continuation.resume(returning: "Egypt")
                }
            }
        }
    }

    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Resume authorization continuation if waiting
        authContinuation?.resume(returning: status)
        authContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationContinuation?.resume(returning: locations.first)
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(returning: nil)
        locationContinuation = nil
    }
}
