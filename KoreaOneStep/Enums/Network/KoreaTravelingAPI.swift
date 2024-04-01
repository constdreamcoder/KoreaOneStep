//
//  KoreaTravelingAPI.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 4/1/24.
//

import Foundation
import Alamofire

enum KoreaTravelingAPI {
    static let radiusDefaultValue = FilteringOrder.FilteringDistance.oneKiloMeter.rawValue
    static let arrageDefaultValue = FilteringOrder.title.sortingCode
    static let contentTypeIdDefaultValue = ""
    static let areaCodeDefaultValue = ""
    static let sigunguCodeDefaultValue = ""
    
    case providedImpairmentAidServices(contentId: String)
    case touristDestionationCommonInformation(
        contentId: String,
        contentTypeId: String
    )
    case locationBasedTourismInformation(
        latitude: Double,
        longitude: Double,
        radius: Int,
        arrange: String,
        contentTypeId: String
    )
    case areaCode(areaCode: String)
    case keywordBasedSearching(
        keyword: String,
        areaCode: String,
        sigunguCode: String
    )
    
    var baseURL: String {
        return "https://apis.data.go.kr/B551011/KorWithService1"
    }
    
    var endpoint: String {
        switch self {
        case .providedImpairmentAidServices:
            return "\(baseURL)/detailWithTour1"
        case .touristDestionationCommonInformation:
            return "\(baseURL)/detailCommon1"
        case .locationBasedTourismInformation:
            return "\(baseURL)/locationBasedList1"
        case .areaCode:
            return "\(baseURL)/areaCode1"
        case .keywordBasedSearching:
            return "\(baseURL)/searchKeyword1"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: String] {
        switch self {
        case .providedImpairmentAidServices(let contentId):
            return [
                "serviceKey": APIKeys.serviceKey, // 필수, 인증키(서비스키)
                "numOfRows": "30", // 한페이지결과수
                "pageNo": "1", // 페이지번호
                "MobileOS": "IOS", // OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
                "MobileApp": "AppTest", // 필수, 서비스명(어플명)
                "contentId": contentId, // 필수, 콘텐츠ID
                "_type": "json" // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
            ]
        case .touristDestionationCommonInformation(let contentId, let contentTypeId):
            return [
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
        case .locationBasedTourismInformation(let latitude, let longitude, let radius, let arrange, let contentTypeId):
            return [
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
        case .areaCode(let areaCode):
            return [
                "serviceKey": APIKeys.serviceKey, // 필수, 인증키(서비스키)
                "numOfRows": "500", // 한페이지 결과수
                "pageNo": "1", // 페이지 번호
                "MobileOS": "IOS", // 필수, OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
                "MobileApp": "AppTest", // 필수, 서비스명(어플명)
                "_type": "json", // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
                "areaCode": areaCode // 지역코드
            ]
        case .keywordBasedSearching(let keyword, let areaCode, let sigunguCode):
            return [
                "serviceKey": APIKeys.serviceKey, // 필수, 인증키(서비스키)
                "numOfRows": "300", // 한페이지 결과수
                "pageNo": "1", // 페이지 번호
                "MobileOS": "IOS", // 필수, OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
                "MobileApp": "AppTest", // 필수, 서비스명(어플명)
                "listYN": "Y", // 목록구분(Y=목록, N=개수)
                "arrange": "O", // 정렬구분(A=제목순, C=수정일순, D=생성일순)대표이미지가반드시있는정렬(O=제목순, Q=수정일순, R=생성일순)
                "keyword": keyword, // 검색요청할키워드(국문=인코딩필요)
                "_type": "json", // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
                "areaCode": areaCode, // 지역코드
                "sigunguCode": sigunguCode // 시군구 코드(지역코드 필수)
            ]
        }
    }
    
    
}
