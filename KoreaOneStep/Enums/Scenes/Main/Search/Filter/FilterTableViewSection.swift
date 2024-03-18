//
//  FilterTableViewSection.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/11/24.
//

import Foundation

enum FilterTableViewSection: Int, CaseIterable {
    case selectRegion
    case selectSiGunGu
    
    var sectionTitle: String {
        switch self {
        case .selectRegion:
            return "지역 선택"
        case .selectSiGunGu:
            return "시군구 선택"
        }
    }
}
