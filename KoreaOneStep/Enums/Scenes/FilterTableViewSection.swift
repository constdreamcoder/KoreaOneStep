//
//  FilterTableViewSection.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/11/24.
//

import Foundation

enum FilterTableViewSection: String, CaseIterable {
    case selectRegion = "지역 선택"
    case selectSiGunGu = "시군구 선택"
    
    var tagList: [String] {
        switch self {
        case .selectRegion:
            return ["서울", "인천", "대전", "대구", "광주", "부산", "울산", "세종특별자치시", "경기도", "강원특별자치도", "충청북도", "충청남도", "경상북도", "경상남도", "전북특별자치도", "전라남도", "제주도"]
        case .selectSiGunGu:
            return ["충청남도", "경상북도", "경상남도", "전북특별자치도", "전라남도", "제주도"]
        }
    }
}
