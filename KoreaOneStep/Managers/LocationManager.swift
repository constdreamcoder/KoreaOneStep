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
    
    typealias FetchLocationCompletion = (CLLocationCoordinate2D?, Error?, Bool) -> Void
    
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
    
    override func startUpdatingLocation() {
        super.startUpdatingLocation()
    }
    
    override func stopUpdatingLocation() {
        super.stopUpdatingLocation()
    }
    
    func fetchLocation(completion: @escaping FetchLocationCompletion) {
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
            
            fetchLocationCompletion?(coordinate, nil, false)
        }
        
        stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fetchLocationCompletion?(nil, error, false)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.global().async { [weak self] in
            guard let weakSelf = self else { return }
            
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    switch manager.authorizationStatus {
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("Location Auth: Allow")
                        weakSelf.startUpdatingLocation()
                    case .notDetermined:
                        print("notDetermined")
                        weakSelf.requestAuthorization()
                    case .restricted:
                        print("restricted")
                    case .denied:
                        print("denied")
                        weakSelf.fetchLocationCompletion?(nil, nil, true)
                    @unknown default:
                        print("Error")
                    }
                }
            }
        }
    }
}
