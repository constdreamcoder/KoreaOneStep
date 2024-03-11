//
//  SettingTableViewCellTitle.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/10/24.
//

import UIKit

enum SettingTableViewCellTitle: String, CaseIterable {
    case goBackToMain = "검색화면으로 이동"
    case goBackToBookmark = "북마크로 이동"
    case removeAllBookmarkRecords = "북마크 모두 삭제하기"
    
    var titleColor: UIColor {
        switch self {
        case .goBackToMain, .goBackToBookmark:
            return .customBlack
        case .removeAllBookmarkRecords:
            return .customRed
        }
    }
}
