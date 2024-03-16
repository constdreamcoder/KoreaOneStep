//
//  FilteringOrder.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/14/24.
//

import Foundation

enum FilteringOrder: String, CaseIterable {
    case title = "제목순"
    case updatedDate = "수정일순"
    case createdDate = "생성일순"
    case distance = "거리순"
        
    var sortingCode: String {
        switch self {
        case .title:
            return "O"
        case .updatedDate:
            return "Q"
        case .createdDate:
            return "R"
        case .distance:
            return "S"
        }
    }
    
    enum FilteringDistance: Int, CaseIterable {
        case oneHundredMeter = 100
        case threeHundredMeters = 300
        case fiveHundredMeters = 500
        case oneKiloMeter = 1000
        case threeKiloMeters = 3000
        case fiveKiloMeters = 5000
        
        var getDistanceStringWithUnit: String {
            switch self {
            case .oneHundredMeter, .threeHundredMeters, .fiveHundredMeters:
                return "\(self.rawValue)m"
            case .oneKiloMeter, .threeKiloMeters, .fiveKiloMeters:
                return "\(self.rawValue/1000)km"
            }
        }
    }
}
