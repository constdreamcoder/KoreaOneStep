//
//  ToastMessage.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/21/24.
//

import Foundation

enum ToastMessage {
    enum Success {
        static let removeAllBookmarks = "북마크가 성공적으로 모두 삭제되었습니다."
    }
    
    enum Failure {
        static let removeAllBookmarks = "북마크 기록 모두 삭제에 실패하였습니다."
        static let noBookmarkContents = "삭제할 북마크 기록이 존재하지 않습니다."
        static let noSearchingResults = "검색 결과가 존재하지 않습니다."
    }
}
