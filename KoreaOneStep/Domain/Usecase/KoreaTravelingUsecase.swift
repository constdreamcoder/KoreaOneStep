//
//  KoreaTravelingUsecase2.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 10/28/24.
//

import Foundation
import RxSwift

protocol KoreaTravelingUsecaseProtocol {
    func fetchProvidedImpairmentAidServices(contentId: String) -> Single<IASItem>
    func fetchTouristDestionationCommonInformation(contentId: String, contentTypeId: String) -> Single<CIItem>
    func fetchLocationBasedTourismInformation(latitude: Double, longitude: Double, radius: Int, arrange: String, contentTypeId: String) -> Single<[LBItem]>
    func fetchAreaCode(areaCode: String) -> Single<[ACItem]>
    func fetchKeywordBasedSearching(keyword: String, areaCode: String, sigunguCode: String) -> Single<[KSItem]>
}

final class KoreaTravelingUsecase: KoreaTravelingUsecaseProtocol {
    private let repository: KoreaTravelingRepositoryProtocol
    
    init(repository: KoreaTravelingRepositoryProtocol) {
        self.repository = repository
    }
    
    
    func fetchProvidedImpairmentAidServices(contentId: String) -> Single<IASItem> {
        repository.fetchProvidedImpairmentAidServices(
            api: .providedImpairmentAidServices(
                contentId: contentId
            )
        )
    }
    
    func fetchTouristDestionationCommonInformation(
        contentId: String,
        contentTypeId: String
    ) -> Single<CIItem> {
        repository.fetchTouristDestionationCommonInformation(
            api: .touristDestionationCommonInformation(
                contentId: contentId,
                contentTypeId: contentTypeId
            )
        )
    }
    
    func fetchLocationBasedTourismInformation(
        latitude: Double,
        longitude: Double,
        radius: Int,
        arrange: String,
        contentTypeId: String
    ) -> Single<[LBItem]> {
        repository.fetchLocationBasedTourismInformation(
            api: .locationBasedTourismInformation(
                latitude: latitude,
                longitude: longitude,
                radius: radius,
                arrange: arrange,
                contentTypeId: contentTypeId
            )
        )
    }
    
    func fetchAreaCode(areaCode: String) -> Single<[ACItem]> {
        repository.fetchAreaCode(api: .areaCode(areaCode: areaCode))
    }
    
    func fetchKeywordBasedSearching(
        keyword: String,
        areaCode: String,
        sigunguCode: String
    ) -> Single<[KSItem]> {
        repository.fetchKeywordBasedSearching(
            api: .keywordBasedSearching(
                keyword: keyword,
                areaCode: areaCode,
                sigunguCode: sigunguCode
            )
        )
    }
}

