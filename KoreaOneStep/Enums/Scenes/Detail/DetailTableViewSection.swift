//
//  DetailTableViewSection.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/12/24.
//

import UIKit

enum DetailTableViewSection: Int, CaseIterable {
    case descriptionSection = 0
    case serviceDetailSection = 1
    
    enum DescriptionSection: CaseIterable {
        case regionDetailCell
        case phoneNumberCell
        case addressCell
        case serviceProvidedCell
    }
    
    enum ServiceDetailSection: CaseIterable {
        case physicalDisability
        case visualImpairment
        case hearingImpairment
        case familiesWithInfantsAndToddlers
        case elderlyPeople
        
        var providedServiceNumber: Int {
            switch self {
            case .physicalDisability:
                return PhysicalDisability.allCases.count
            case .visualImpairment:
                return VisualImpairment.allCases.count
            case .hearingImpairment:
                return HearingImpairment.allCases.count
            case .familiesWithInfantsAndToddlers:
                return FamiliesWithInfantsAndToddlers.allCases.count
            case .elderlyPeople:
                return ElderlyPeople.allCases.count
            }
        }
        
        var serviceImage: UIImage {
            switch self {
            case .physicalDisability:
                return UIImage.physicalDisability
            case .visualImpairment:
                return UIImage.visualImpairment
            case .hearingImpairment:
                return UIImage.hearingImpairment
            case .familiesWithInfantsAndToddlers:
                return UIImage.familiesWithInfantsAndToddlers
            case .elderlyPeople:
                return UIImage.elderlyPeople
            }
        }
        
        var serviceTitleList: [String] {
            switch self {
            case .physicalDisability:
                return PhysicalDisability.allCases.map { $0.rawValue }
            case .visualImpairment:
                return VisualImpairment.allCases.map { $0.rawValue }
            case .hearingImpairment:
                return HearingImpairment.allCases.map { $0.rawValue }
            case .familiesWithInfantsAndToddlers:
                return FamiliesWithInfantsAndToddlers.allCases.map { $0.rawValue }
            case .elderlyPeople:
                return ElderlyPeople.allCases.map { $0.rawValue }
            }
        }
        
        enum PhysicalDisability: String, CaseIterable {
            case parkingStatus = "주차여부"
            case publicTransport = "대중교통"
            case coreMovementLine = "핵심동선"
            case ticketBox = "매표소"
            case promotionalMaterial = "홍보물"
            case wheelchair = "휠체어"
            case elevator = "엘리베이터"
            case restroom = "화장실"
            case seat = "관람석(좌석)"
        }
       
        enum VisualImpairment: String, CaseIterable {
            case bailieBlock = "점자블록"
            case guide = "안내요원"
            case audioGuidance = "음성안내"
            case LargePrintOrBraillePromotionalMaterials = "큰활자/점자 홍보물"
            case brailleSign = "점자표지판"
            case guidanceFacility = "유도안내설비"
        }
        
        enum HearingImpairment: String, CaseIterable {
            case signLanguageGuidance = "수어안내"
            case subtitle = "자막"
        }
        
        enum FamiliesWithInfantsAndToddlers: String, CaseIterable {
            case strollerRent = "유아차 대여"
        }
        
        enum ElderlyPeople: String, CaseIterable {
            case wheelChairRent = "휠체어 대여"
            case mobilityAidsRent = "이동보조도구 대여"
        }
    }
}

