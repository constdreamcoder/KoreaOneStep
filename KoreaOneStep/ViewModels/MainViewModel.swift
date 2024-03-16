//
//  MainViewModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/16/24.
//

import Foundation
import CoreLocation

final class MainViewModel: NSObject {
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputSearchingDistance: Observable<(CLLocationCoordinate2D?, FilteringOrder.FilteringDistance)> = Observable((nil, .oneKiloMeter))
    
    let outputLocationBasedTouristDestinationList: Observable<[LBItem]> = Observable([])
    let outputUserCurrentLocationInfo: Observable<CLLocationCoordinate2D?> = Observable(nil)
        
    override init() {
        super.init()
                
        inputViewDidLoadTrigger.bind { trigger in
            guard let trigger = trigger else { return }
            
            LocationManager.shared.fetchLocation { [weak self] coordinate, error in
                guard let weakSelf = self else { return }
                
                guard error == nil else {
                    print("Location Searching Error: ", error)
                    return
                }
                
                guard let coordinate = coordinate else {
                    print("Something is wrong.")
                    return
                }
                
                weakSelf.outputUserCurrentLocationInfo.value = coordinate
                
                KoreaTravelingManager.shared.fetchLocationBasedTourismInformation(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                ) { touristDestinationList in
                    weakSelf.outputLocationBasedTouristDestinationList.value = touristDestinationList
                }
            }
        }
        
        inputSearchingDistance.bind { coordinate, searchingDistance in
            guard let coordinate = coordinate else { return  }
            
            KoreaTravelingManager.shared.fetchLocationBasedTourismInformation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                radius: searchingDistance.rawValue
            ) { [weak self] touristDestinationList in
                guard let weakSelf = self else { return }
                weakSelf.outputLocationBasedTouristDestinationList.value = touristDestinationList
            }
        }
    }
}
