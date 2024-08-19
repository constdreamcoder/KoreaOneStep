//
//  BookmarkSectionData.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 8/18/24.
//

import Foundation
import Differentiator

struct BookmarkSectionData {
    var items: [Item]
}

extension BookmarkSectionData: SectionModelType {
    typealias Item = Bookmark
    
    init(original: BookmarkSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}
