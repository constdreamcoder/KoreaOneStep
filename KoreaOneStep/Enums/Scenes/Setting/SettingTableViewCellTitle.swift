//
//  SettingTableViewCellTitle.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/10/24.
//

import UIKit

enum SettingTableViewCellTitle: String, CaseIterable {
    case removeAllBookmarkRecords = "북마크 모두 삭제하기"
    
    var titleColor: UIColor {
        switch self {
        case .removeAllBookmarkRecords:
            return .customRed
        }
    }
}
