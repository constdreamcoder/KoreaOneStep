//
//  MainViewModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/16/24.
//

import Foundation
import CoreLocation

struct SearchResulData {
    let locationBasedTouristDestination: LBItem
    let isBookmarked: Bool
}

final class MainViewModel {
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputForTableViewUpdate: Observable<(CLLocationCoordinate2D?, FilteringOrder.FilteringDistance, FilteringOrder)> = Observable((nil, .oneKiloMeter, .title))
    let inputTourType: Observable<(CLLocationCoordinate2D?, FilteringOrder.FilteringDistance, FilteringOrder, TourType?)> = Observable((nil, .oneKiloMeter, .title, nil))
    let inputAddNewBookmark: Observable<LBItem?> = Observable(nil)
    let inputRemoveBookmark: Observable<LBItem?> = Observable(nil)
    let inputContentVCTableViewDidSelectRowAtTrigger: Observable<LBItem?> = Observable(nil)
    let inputSearchVCTableViewDidSelectRowAt: Observable<KSItem?> = Observable(nil)
    let inputDetailVCLeftBarButtonItemTappedTrigger: Observable<Void?> = Observable(nil)
    let inputDetailVCViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputDetailVCAddressCellTappTrigger: Observable<(Double?, Double?)> = Observable((nil, nil))
    let inputActivityIndicatorStopTrigger: Observable<Void?> = Observable(nil)
    let inputActivityIndicatorStartTrigger: Observable<Void?> = Observable(nil)
    
    let outputLocationBasedTouristDestinationList: Observable<[SearchResulData]?> = Observable(nil)
    let outputUserCurrentLocationInfoToMainVC: Observable<CLLocationCoordinate2D?> = Observable(nil)
    let outputUserCurrentLocationInfoToContentVC: Observable<CLLocationCoordinate2D?> = Observable(nil)
    let outputSelectedTouristDestination: Observable<LBItem?> = Observable(nil)
    let outputTappedTouristDestination: Observable<KSItem?> = Observable(nil)
    let outputDetailVCLeftBarButtonItemTappedTrigger: Observable<Void?> = Observable(nil)
    let outputDetailVCViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let outputDetailVCAddressCellTappTrigger: Observable<(Double?, Double?)> = Observable((nil, nil))
    let outputActivityIndicatorStopTrigger: Observable<Void?> = Observable(nil)
    let outputActivityIndicatorStartTrigger: Observable<Void?> = Observable(nil)
    let outputShowAlertTriggerForAuthorization: Observable<Bool> = Observable(false)
    
   init() {
        inputViewDidLoadTrigger.bind { trigger in
            guard let trigger = trigger else { return }
            
            LocationManager.shared.fetchLocation { [weak self] coordinate, error, isDenied in
                guard let weakSelf = self else { return }
                
                guard error == nil else {
                    print("위치 찾기 에러 발생: ", error)
                    return
                }
                
                guard !isDenied else {
                    print("Denied")
                    weakSelf.outputShowAlertTriggerForAuthorization.value = isDenied
                    return
                }
                
                guard let coordinate = coordinate else {
                    print("Something is wrong.")
                    return
                }
                
                weakSelf.outputUserCurrentLocationInfoToMainVC.value = coordinate
                weakSelf.outputUserCurrentLocationInfoToContentVC.value = coordinate
                
                KoreaTravelingManager.shared.fetchLocationBasedTourismInformation(
                    api: .locationBasedTourismInformation(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude,
                        radius: KoreaTravelingAPI.radiusDefaultValue,
                        arrange: KoreaTravelingAPI.arrageDefaultValue,
                        contentTypeId: KoreaTravelingAPI.contentTypeIdDefaultValue
                    )
                ) { [weak self] touristDestinationList in
                    guard let weakSelf = self else { return }
                    
                    let searchResulDataList = weakSelf.generateSearchResulDataList(touristDestinationList)
                    
                    weakSelf.outputLocationBasedTouristDestinationList.value = searchResulDataList
                }
            }
        }
        
        inputForTableViewUpdate.bind { coordinate, filteringDistance, filteringOrder in
            guard let coordinate = coordinate else { return  }
            
            KoreaTravelingManager.shared.fetchLocationBasedTourismInformation(
                api: .locationBasedTourismInformation(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    radius: filteringDistance.rawValue,
                    arrange: filteringOrder.sortingCode,
                    contentTypeId: KoreaTravelingAPI.contentTypeIdDefaultValue
                )
            ) { [weak self] touristDestinationList in
                guard let weakSelf = self else { return }
                
                let searchResulDataList = weakSelf.generateSearchResulDataList(touristDestinationList)
                
                weakSelf.outputLocationBasedTouristDestinationList.value = searchResulDataList
            }
        }
        
        inputTourType.bind { coordinate, filteringDistance, filteringOrder, tourType in
            guard
                let coordinate = coordinate,
                let tourType = tourType
            else { return }
            
            KoreaTravelingManager.shared.fetchLocationBasedTourismInformation(
                api: .locationBasedTourismInformation(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    radius: filteringDistance.rawValue,
                    arrange: filteringOrder.sortingCode,
                    contentTypeId:  tourType.tourTypeCode
                )
            ) { [weak self] touristDestinationList in
                guard let weakSelf = self else { return }
                
                let searchResulDataList = weakSelf.generateSearchResulDataList(touristDestinationList)

                weakSelf.outputLocationBasedTouristDestinationList.value = searchResulDataList
            }
        }
        
        inputAddNewBookmark.bind { locationBasedTouristDestination in
            guard
                let locationBasedTouristDestination = locationBasedTouristDestination
            else { return }
            
            let filteredBookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).filter { bookmark in
                bookmark.contentId == locationBasedTouristDestination.contentid
            }
            
            if filteredBookmarkList.count >= 1 {
                print("이미 존재하는 북마크입니다.")
                return
            }
        
            let newBookmark = Bookmark(
                contentId: locationBasedTouristDestination.contentid,
                contentTypeId: locationBasedTouristDestination.contenttypeid,
                title: locationBasedTouristDestination.title,
                imageURL: locationBasedTouristDestination.firstimage,
                region: locationBasedTouristDestination.areacode
            )
            
            RealmManager.shared.write(newBookmark)
            RealmManager.shared.getLocationOfDefaultRealm()
        }
        
        inputRemoveBookmark.bind { locationBasedTouristDestination in
            guard
                let locationBasedTouristDestination = locationBasedTouristDestination
            else { return }
            
            let bookmarkList = RealmManager.shared.read(Bookmark.self)
            
            let filteredBookmarkList: [Bookmark] = bookmarkList.filter { bookmark in
                bookmark.contentId == locationBasedTouristDestination.contentid
            }
            
            if filteredBookmarkList.count < 1 {
                print("존재하지 않는 북마크입니다.")
                return
            }
            
            RealmManager.shared.delete(filteredBookmarkList[0])
        }
        
        inputContentVCTableViewDidSelectRowAtTrigger.bind { [weak self] touristDestination in
            guard let weakSelf = self else { return }
            
            guard let touristDestination = touristDestination else { return }
            
            weakSelf.outputSelectedTouristDestination.value = touristDestination
        }
        
        inputSearchVCTableViewDidSelectRowAt.bind { [weak self] selectedTouristDestination in
            guard let weakSelf = self else { return }
           
            weakSelf.outputTappedTouristDestination.value = selectedTouristDestination
        }
        
        inputDetailVCLeftBarButtonItemTappedTrigger.bind { [weak self] trigger in
            guard let weakSelf = self else { return }
            
            guard let trigger = trigger else { return }
            
            weakSelf.outputDetailVCLeftBarButtonItemTappedTrigger.value = trigger
        }
        
        inputDetailVCViewDidLoadTrigger.bind { [weak self] trigger in
            guard let weakSelf = self else { return }
            
            guard let trigger = trigger else { return }
            
            weakSelf.outputDetailVCViewDidLoadTrigger.value = trigger
        }
       
       inputDetailVCAddressCellTappTrigger.bind { [weak self] latitude, longitude in
           guard let weakSelf = self else { return }
           
           guard
                let latitude = latitude,
                let longitude = longitude
           else { return }
           
           weakSelf.outputDetailVCAddressCellTappTrigger.value = (latitude, longitude)
       }
       
       inputActivityIndicatorStopTrigger.bind { [weak self] trigger in
           guard let weakSelf = self else { return }
           
           guard let trigger = trigger else { return }
           
           weakSelf.outputActivityIndicatorStopTrigger.value = trigger
       }
       
       inputActivityIndicatorStartTrigger.bind { [weak self] trigger in
           guard let weakSelf = self else { return }
           
           guard let trigger = trigger else { return }
           
           weakSelf.outputActivityIndicatorStartTrigger.value = trigger
       }
    }
}

extension MainViewModel {
    private func generateSearchResulDataList(_ touristDestinationList: [LBItem] = []) -> [SearchResulData] {
        let bookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
        
        return touristDestinationList.map { lbItem in
            let filteredBookmarkList = bookmarkList.filter { lbItem.contentid == $0.contentId }
            
            if filteredBookmarkList.count >= 1 {
                return SearchResulData(
                    locationBasedTouristDestination: lbItem,
                    isBookmarked: true
                )
            } else {
                return SearchResulData(
                    locationBasedTouristDestination: lbItem,
                    isBookmarked: false
                )
            }
        }
    }
}
