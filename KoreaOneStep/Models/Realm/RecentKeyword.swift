//
//  RecentKeyword.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/20/24.
//

import Foundation
import RealmSwift

final class RecentKeyword: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var keyword: String
    @Persisted var regDate: Date
    
    convenience init(keyword: String) {
        self.init()
        
        self.keyword = keyword
        self.regDate = Date()
    }
}
