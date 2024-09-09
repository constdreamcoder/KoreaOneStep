//
//  MainViewModel2.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 8/21/24.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class MainViewModel2: ViewModelType {
    
    let indicatorTriggerRelay = BehaviorRelay<Bool>(value: false)
    let locationBasedTouristDestinationListRelay = BehaviorRelay<[SearchResulData]>(value: [])
    let userLocationInfoRelay = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let showAlertTriggerForAuthorization: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let showAlertTriggerForAuthorizationRelay = PublishRelay<Bool>()
        let searchLocationBasedTourismInfosTrigger = PublishSubject<CLLocationCoordinate2D>()
        
        searchLocationBasedTourismInfosTrigger
            .flatMap { coordinate in
                KoreaTravelingManager.shared.fetchLocationBasedTourismInformation(
                    api: .locationBasedTourismInformation(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude,
                        radius: KoreaTravelingAPI.radiusDefaultValue,
                        arrange: KoreaTravelingAPI.arrageDefaultValue,
                        contentTypeId: KoreaTravelingAPI.contentTypeIdDefaultValue
                    )
                )
            }
            .bind(with: self) { owner, touristDestinationList in
                owner.locationBasedTouristDestinationListRelay.accept(owner.generateSearchResulDataList(touristDestinationList))
            }
            .disposed(by: disposeBag)
       
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                LocationManager.shared.fetchLocation { [weak self] coordinate, error, isDenied in
                    guard let weakSelf = self else { return }
                    
                    guard error == nil else {
                        print("위치 찾기 에러 발생: ", error)
                        return
                    }
                    
                    guard !isDenied else {
                        print("Denied")
                        weakSelf.userLocationInfoRelay.accept(nil)
                        showAlertTriggerForAuthorizationRelay.accept(isDenied)
                        return
                    }
                    
                    guard let coordinate = coordinate else {
                        print("Something is wrong.")
                        return
                    }
                    
                    owner.userLocationInfoRelay.accept(coordinate)
                    searchLocationBasedTourismInfosTrigger.onNext(coordinate)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            showAlertTriggerForAuthorization: showAlertTriggerForAuthorizationRelay.asDriver(onErrorJustReturn: false)
        )
    }
}

extension MainViewModel2 {
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
