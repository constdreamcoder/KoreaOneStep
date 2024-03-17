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
    
    let inputFilteringDistance: Observable<(CLLocationCoordinate2D?, FilteringOrder.FilteringDistance, FilteringOrder)> = Observable((nil, .oneKiloMeter, .title))
    let inputFilteringOrder: Observable<(CLLocationCoordinate2D?, FilteringOrder.FilteringDistance, FilteringOrder)> = Observable((nil, .oneKiloMeter, .title))
    let inputTourType: Observable<(CLLocationCoordinate2D?, TourType?)> = Observable((nil, nil))
    
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
        
        // TODO: - 리팩토링하기: inputFilteringOrder와 합치기
        inputFilteringDistance.bind { coordinate, filteringDistance, filteringOrder in
            guard let coordinate = coordinate else { return  }
            
            KoreaTravelingManager.shared.fetchLocationBasedTourismInformation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                radius: filteringDistance.rawValue,
                arrange: filteringOrder.sortingCode
            ) { [weak self] touristDestinationList in
                guard let weakSelf = self else { return }
                weakSelf.outputLocationBasedTouristDestinationList.value = touristDestinationList
            }
        }
        
        // TODO: - 리팩토링하기: inputFilteringDistance와 합치기
        inputFilteringOrder.bind { coordinate, filteringDistance, filteringOrder in
            guard let coordinate = coordinate else { return  }

            KoreaTravelingManager.shared.fetchLocationBasedTourismInformation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                radius: filteringDistance.rawValue,
                arrange: filteringOrder.sortingCode
            ) { [weak self] touristDestinationList in
                guard let weakSelf = self else { return }
                weakSelf.outputLocationBasedTouristDestinationList.value = touristDestinationList
            }
        }
        
        inputTourType.bind { coordinate, tourType in
            guard
                let coordinate = coordinate,
                let tourType = tourType
            else { return }
            
            KoreaTravelingManager.shared.fetchLocationBasedTourismInformation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                tourTypeCode: tourType.tourTypeCode
            ) { [weak self] touristDestinationList in
                guard let weakSelf = self else { return }
                weakSelf.outputLocationBasedTouristDestinationList.value = touristDestinationList
            }
        }
    }
}
