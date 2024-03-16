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
    
    private let baseURL = "https://apis.data.go.kr/B551011/KorWithService1"
    
    func fetchLocationBasedTourismInformation(
        latitude: Double,
        longitude: Double,
        radius: Int = FilteringOrder.FilteringDistance.oneKiloMeter.rawValue,
        completionHandler: @escaping ([LBItem]) -> Void
    ) {
        let urlString = "\(baseURL)/locationBasedList1"
        
        // TODO: 나중에 MobileApp 번들ID로 변경
        let parameters = [
            "serviceKey": APIKeys.serviceKey, // 인증키
            "numOfRows": "30", // 한페이지 결과수
            "pageNo": "1", // 페이지 번호
            "MobileOS": "IOS", // OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
            "MobileApp": "AppTest", // 서비스명(어플명)
            "listYN": "Y", // 목록구분(Y=목록, N=개수)
            "arrange": "O", // 정렬구분(A=제목순, C=수정일순, D=생성일순, E=거리순) 대표이미지가반드시있는정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
            "mapX": "\(longitude)", // GPS X좌표(WGS84 경도좌표)
            "mapY": "\(latitude)", // GPS Y좌표(WGS84 위도좌표)
            "radius": "\(radius)", // 거리반경(단위:m) , Max값 20000m=20Km
            "_type": "json", // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
            "contentTypeId": "" // 관광타입(12:관광지, 14:문화시설, 15:축제공연행사, 25:여행코스, 28:레포츠, 32:숙박, 38:쇼핑, 39:음식점) ID
        ]
        
        // TODO: - 네트워크 에러 처리하기
        AF.request(
            urlString,
            method: .get,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).responseDecodable(of: LocationBasedTourismInformationModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.response.body.items.item)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
}
