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
    
    let outputLocationBasedTouristDestinationList: Observable<[LBItem]> = Observable([])
        
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
                
                KoreaTravelingManager.shared.fetchLocationBasedTourismInformation(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                ) { touristDestinationList in
                    weakSelf.outputLocationBasedTouristDestinationList.value = touristDestinationList
                }
            }
        }
    }
}
