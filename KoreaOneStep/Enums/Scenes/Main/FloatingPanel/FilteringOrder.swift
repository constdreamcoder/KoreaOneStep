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
    
    enum FilteringDistance: String, CaseIterable {
        case oneHundredMeter = "100m"
        case threeHundredMeters = "300m"
        case fiveHundredMeters = "500m"
        case oneKiloMeter = "1km"
        case threeKiloMeters = "3km"
        case fiveKiloMeters = "5km"
    }
}
