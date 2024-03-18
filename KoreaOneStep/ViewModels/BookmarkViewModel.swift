//
//  BookmarkViewModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/18/24.
//

import Foundation

final class BookmarkViewModel {
    let inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    
    let outputBookmarkList: Observable<[Bookmark]> = Observable([])
    
    init() {
        inputViewWillAppearTrigger.bind { [weak self] trigger in
            guard let weakSelf = self else { return }
            
            guard let trigger = trigger else { return }
            
            let bookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
            
            weakSelf.outputBookmarkList.value = bookmarkList
        }
    }
}
