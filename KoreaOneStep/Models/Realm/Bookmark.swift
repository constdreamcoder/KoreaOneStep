//
//  Bookmark.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/18/24.
//

import RealmSwift
import Foundation

final class Bookmark: Object {
    @Persisted(primaryKey: true) var contentId: String
    @Persisted var contentTypeId: String
    @Persisted var title: String
    @Persisted var imageURL: String
    @Persisted var region: String
    @Persisted var regDate: Date
    
    convenience init(contentId: String, contentTypeId: String, title: String, imageURL: String, region: String) {
        self.init()
        
        self.contentId = contentId
        self.contentTypeId = contentTypeId
        self.title = title
        self.imageURL = imageURL
        self.region = region
        self.regDate = Date()
    }
}
