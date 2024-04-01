//
//  KoreaTravelingManager.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/16/24.
//

import Foundation
import Alamofire

final class KoreaTravelingManager {
    static let shared = KoreaTravelingManager()
    
    private init() {}
        
    func fetchProvidedImpairmentAidServices(
        api: KoreaTravelingAPI,
        completionHandler: @escaping (IASItem) -> Void
    ) {
        
        // TODO: - 네트워크 에러 처리하기
        AF.request(
            api.endpoint,
            method: .get,
            parameters: api.parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: ProvidedImpairmentAidServicesModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.response.body.items.item[0])
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchTouristDestionationCommonInformation(
        api: KoreaTravelingAPI,
        completionHandler: @escaping (CIItem) -> Void
    ) {
        
        // TODO: - 네트워크 에러 처리하기
        AF.request(
            api.endpoint,
            method: api.method,
            parameters: api.parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: TouristDestionationCommonInformationModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.response.body.items.item[0])
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchLocationBasedTourismInformation(
        api: KoreaTravelingAPI,
        completionHandler: @escaping ([LBItem]) -> Void
    ) {
        
        // TODO: - 네트워크 에러 처리하기
        AF.request(
            api.endpoint,
            method: api.method,
            parameters: api.parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: LocationBasedTourismInformationModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.response.body.items.item)
            case .failure(let failure):
                completionHandler([])
                print(failure)
            }
        }
    }
    
    func fetchAreaCode(
        api: KoreaTravelingAPI,
        completionHandler: @escaping ([ACItem]) -> Void
    ) {
        
        // TODO: - 네트워크 에러 처리하기
        AF.request(
            api.endpoint,
            method: api.method,
            parameters: api.parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: AreaCodeModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.response.body.items.item)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchKeywordBasedSearching(
        api: KoreaTravelingAPI,
        completionHandler: @escaping ([KSItem]) -> Void
    ) {
        
        // TODO: - 네트워크 에러 처리하기
        AF.request(
            api.endpoint,
            method: api.method,
            parameters: api.parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: KeywordBasedSearchgingModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.response.body.items.item)
            case .failure(let failure):
                print(failure)
                completionHandler([])
            }
        }
    }
    
}
