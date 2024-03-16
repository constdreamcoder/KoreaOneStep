//
//  LocationManager.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/16/24.
//

import Foundation
import CoreLocation

final class LocationManager: CLLocationManager {
    
    static let shared = LocationManager()
    
    typealias FetchLocationCompletion = (CLLocationCoordinate2D?, Error?) -> Void
    
    private var fetchLocationCompletion: FetchLocationCompletion?
        
    private override init() {
        super.init()
        
        self.delegate = self
        
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        self.desiredAccuracy = kCLLocationAccuracyBest

        self.requestWhenInUseAuthorization()
    }
}

extension LocationManager {
    
    override func startUpdatingHeading() {
        super.startUpdatingHeading()
    }
    
    override func stopUpdatingHeading() {
        super.stopUpdatingHeading()
    }
    
    override func requestLocation() {
        super.requestLocation()
    }
    
    func fetchLocation(completion: @escaping FetchLocationCompletion) {
        self.requestLocation()
        
        self.fetchLocationCompletion = completion
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
            print(coordinate.latitude)
            print(coordinate.longitude)
            
            self.fetchLocationCompletion?(coordinate, nil)
            
            self.fetchLocationCompletion = nil
        }
        
        stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.fetchLocationCompletion?(nil, error)
        
        self.fetchLocationCompletion = nil
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Auth: Allow")
            self.startUpdatingHeading()
        case .notDetermined:
            print("notDetermined")
            requestAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        @unknown default:
            print("Error")
        }
    }
}
