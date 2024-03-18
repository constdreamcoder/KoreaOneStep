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
    
    func fetchProvidedImpairmentAidServices(
        contentId: String,
        completionHandler: @escaping (IASItem) -> Void
    ) {
        let urlString = "\(baseURL)/detailWithTour1"
        
        let parameters = [
            "serviceKey": APIKeys.serviceKey, // 필수, 인증키(서비스키)
            "numOfRows": "30", // 한페이지결과수
            "pageNo": "1", // 페이지번호
            "MobileOS": "IOS", // OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
            "MobileApp": "AppTest", // 필수, 서비스명(어플명)
            "contentId": contentId, // 필수, 콘텐츠ID
            "_type": "json" // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
        ]
        
        // TODO: - 네트워크 에러 처리하기
        AF.request(
            urlString,
            method: .get,
            parameters: parameters,
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
        contentId: String,
        contentTypeId: String,
        completionHandler: @escaping (CIItem) -> Void
    ) {
        let urlString = "\(baseURL)/detailCommon1"
        
        let parameters = [
            "serviceKey": APIKeys.serviceKey, // 필수, 인증키(서비스키)
            "numOfRows": "30", // 한페이지결과수
            "pageNo": "1", // 페이지번호
            "MobileOS": "IOS", // 필수, OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
            "MobileApp": "AppTest", // 필수, 서비스명(어플명)
            "contentId": contentId, // 필수, 콘텐츠ID
            "defaultYN": "Y", // 기본정보조회여부( Y,N )
            "firstImageYN": "Y", // 원본, 썸네일대표 이미지, 이미지 공공누리유형정보 조회여부( Y,N )
            "areacodeYN": "Y", // 지역코드, 시군구코드조회여부( Y,N )
            "catcodeYN": "Y", // 대,중,소분류코드조회여부( Y,N )
            "addrinfoYN": "Y", // 주소, 상세주소조회여부( Y,N )
            "mapinfoYN": "Y", // 좌표X, Y 조회여부( Y,N )
            "overviewYN": "Y", // 콘텐츠개요조회여부( Y,N )
            "_type": "json", // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
            "contentTypeId": contentTypeId // 관광타입(관광지, 숙박 등) ID
        ]
        
        // TODO: - 네트워크 에러 처리하기
        AF.request(
            urlString,
            method: .get,
            parameters: parameters,
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
        latitude: Double,
        longitude: Double,
        radius: Int = FilteringOrder.FilteringDistance.oneKiloMeter.rawValue,
        arrange: String = FilteringOrder.title.sortingCode,
        tourTypeCode contentTypeId: String = "",
        completionHandler: @escaping ([LBItem]) -> Void
    ) {
        let urlString = "\(baseURL)/locationBasedList1"
        
        // TODO: 나중에 MobileApp 번들ID로 변경
        let parameters = [
            "serviceKey": APIKeys.serviceKey, // 인증키
            "numOfRows": "30", // 한페이지 결과수
            "pageNo": "1", // 페이지 번호
            "MobileOS": "IOS", // 필수, OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
            "MobileApp": "AppTest", // 필수, 서비스명(어플명)
            "listYN": "Y", // 목록구분(Y=목록, N=개수)
            "arrange": arrange, // 정렬구분(A=제목순, C=수정일순, D=생성일순, E=거리순) 대표이미지가반드시있는정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
            "mapX": "\(longitude)", // 필수, GPS X좌표(WGS84 경도좌표)
            "mapY": "\(latitude)", // 필수, GPS Y좌표(WGS84 위도좌표)
            "radius": "\(radius)", // 필수, 거리반경(단위:m) , Max값 20000m=20Km
            "_type": "json", // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
            "contentTypeId": contentTypeId // 관광타입(12:관광지, 14:문화시설, 15:축제공연행사, 25:여행코스, 28:레포츠, 32:숙박, 38:쇼핑, 39:음식점) ID
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
    
    func fetchAreaCode(
        areaCode: String = "",
        completionHandler: @escaping ([ACItem]) -> Void
    ) {
        let urlString = "\(baseURL)/areaCode1"
        
        // TODO: 나중에 MobileApp 번들ID로 변경
        let parameters = [
            "serviceKey": APIKeys.serviceKey, // 필수, 인증키(서비스키)
            "numOfRows": "500", // 한페이지 결과수
            "pageNo": "1", // 페이지 번호
            "MobileOS": "IOS", // 필수, OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
            "MobileApp": "AppTest", // 필수, 서비스명(어플명)
            "_type": "json", // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
            "areaCode": areaCode // 지역코드
        ]
        
        // TODO: - 네트워크 에러 처리하기
        AF.request(
            urlString,
            method: .get,
            parameters: parameters,
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
    
}
