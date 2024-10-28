//
//  KoreaTravelingRepository2.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 10/28/24.
//

import Foundation
import RxMoya
import RxSwift

protocol KoreaTravelingRepositoryProtocol {
    func fetchProvidedImpairmentAidServices(api: KoreaTravelingAPI) -> Single<IASItem>
    func fetchTouristDestionationCommonInformation(api: KoreaTravelingAPI) -> Single<CIItem>
    func fetchLocationBasedTourismInformation(api: KoreaTravelingAPI) -> Single<[LBItem]>
    func fetchAreaCode(api: KoreaTravelingAPI) -> Single<[ACItem]>
    func fetchKeywordBasedSearching(api: KoreaTravelingAPI) -> Single<[KSItem]>
}

final class KoreaTravelingRepository: KoreaTravelingRepositoryProtocol {
    private let network: NetworkManagerProtocl
    
    init(network: NetworkManagerProtocl) {
        self.network = network
    }
    
    func fetchProvidedImpairmentAidServices(api: KoreaTravelingAPI) -> Single<IASItem> {
        network
            .request(api)
            .map(ProvidedImpairmentAidServicesDTO.self)
            .map { $0.response.body.items.item[0] }
    }
    
    func fetchTouristDestionationCommonInformation(api: KoreaTravelingAPI) -> Single<CIItem> {
        network
            .request(api)
            .map(TouristDestionationCommonInformationDTO.self)
            .map { $0.response.body.items.item[0] }
    }
    
    func fetchLocationBasedTourismInformation(api: KoreaTravelingAPI) -> Single<[LBItem]> {
        network
            .request(api)
            .map(LocationBasedTourismInformationDTO.self)
            .map { $0.response.body.items.item }
    }
    
    func fetchAreaCode(api: KoreaTravelingAPI) -> Single<[ACItem]> {
        network
            .request(api)
            .map(AreaCodeDTO.self)
            .map { $0.response.body.items.item }
    }
    
    func fetchKeywordBasedSearching(api: KoreaTravelingAPI) -> Single<[KSItem]> {
        network
            .request(api)
            .map(KeywordBasedSearchingDTO.self)
            .map { $0.response.body.items.item }
    }
}
