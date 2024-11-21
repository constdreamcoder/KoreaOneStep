//
//  NetworkManager2.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 10/28/24.
//

import Foundation
import Moya
import RxSwift

protocol NetworkManagerProtocl {
    func request(_ target: KoreaTravelingAPI) -> Single<Response>
}

final class NetworkManager: NetworkManagerProtocl {
    private let provider: MoyaProvider<KoreaTravelingAPI>
    
    init() {
        provider = MoyaProvider<KoreaTravelingAPI>()
    }
    
    func request(_ target: KoreaTravelingAPI) -> Single<Response> {
        return Single<Response>.create { [weak self] singleObserver in
            guard let self else { return Disposables.create() }
            
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    singleObserver(.success(response))
                case .failure(let moyaError):
                    print(moyaError)
                    // TODO: - 네트워크 오류 처리하기
                    // singleObserver(.failure(moyaError))
                }
            }
            return Disposables.create()
        }
    }
}
