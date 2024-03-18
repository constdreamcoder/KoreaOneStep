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

final class MainViewModel: NSObject {
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputForTableViewUpdate: Observable<(CLLocationCoordinate2D?, FilteringOrder.FilteringDistance, FilteringOrder)> = Observable((nil, .oneKiloMeter, .title))
    let inputTourType: Observable<(CLLocationCoordinate2D?, TourType?)> = Observable((nil, nil))
    let inputAddNewBookmark: Observable<LBItem?> = Observable(nil)
    let inputRemoveBookmark: Observable<LBItem?> = Observable(nil)
    
    let outputLocationBasedTouristDestinationList: Observable<[SearchResulData]> = Observable([])
    let outputUserCurrentLocationInfo: Observable<CLLocationCoordinate2D?> = Observable(nil)
        
    override init() {
        super.init()
                
        inputViewDidLoadTrigger.bind { trigger in
            guard let trigger = trigger else { return }
            
            LocationManager.shared.fetchLocation { [weak self] coordinate, error in
                guard let weakSelf = self else { return }
                
                guard error == nil else {
                    print("위치 찾기 에러 발생: ", error)
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
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                radius: filteringDistance.rawValue,
                arrange: filteringOrder.sortingCode
            ) { [weak self] touristDestinationList in
                guard let weakSelf = self else { return }
                
                let searchResulDataList = weakSelf.generateSearchResulDataList(touristDestinationList)
                
                weakSelf.outputLocationBasedTouristDestinationList.value = searchResulDataList
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
