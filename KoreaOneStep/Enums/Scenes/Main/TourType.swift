//
//  TourType.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/15/24.
//

import Foundation

enum TourType: String, CaseIterable {
    case touristAttractions = "관광지"
    case culturalFacilities = "문화시설"
    case festivalsOrConcerts = "축제공연행사"
    case travelingCourses = "여행코스"
    case leports = "레포츠"
    case accommodations = "숙박 시설"
    case shopping = "쇼핑"
    case restaurants = "음식점"
    
    var tourTypeCode: String {
        switch self {
        case .touristAttractions:
            return "12"
        case .culturalFacilities:
            return "14"
        case .festivalsOrConcerts:
            return "15"
        case .travelingCourses:
            return "25"
        case .leports:
            return "28"
        case .accommodations:
            return "32"
        case .shopping:
            return "38"
        case .restaurants:
            return "39"
        }
    }
}
