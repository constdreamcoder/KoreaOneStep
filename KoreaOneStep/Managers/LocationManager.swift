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
        self.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
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
                        
            self.fetchLocationCompletion?(coordinate, nil)
            
            self.fetchLocationCompletion = nil
        }
        
        stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.fetchLocationCompletion?(nil, error)
        
        self.fetchLocationCompletion = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    switch manager.authorizationStatus {
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("Location Auth: Allow")
                        self.startUpdatingLocation()
                    case .notDetermined:
                        print("notDetermined")
                        self.requestAuthorization()
                    case .restricted:
                        print("restricted")
                    case .denied:
                        // TODO: - Alert 창으로 권한을 줄 수 있는 설정창으로 이동하는 트리거 구현하기
                        print("denied")
                    @unknown default:
                        print("Error")
                    }
                }
            }
        }
    }
}
