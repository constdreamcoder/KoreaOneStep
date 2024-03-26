//
//  BookmarkViewModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/18/24.
//

import Foundation

final class BookmarkViewModel {
    let inputForGettingInitialCollectionViewState: Observable<Void?> = Observable(nil)
    let inputForCollectionViewUpdateWithsearchText: Observable<String> = Observable("")
    let inputBookmarkIconButtonTapTrigger: Observable<Bookmark?> = Observable(nil)
    
    let outputBookmarkList: Observable<[Bookmark]> = Observable([])
    
    init() {
        inputForGettingInitialCollectionViewState.bind { [weak self] trigger in
            guard let weakSelf = self else { return }
            
            guard let trigger = trigger else { return }
            
            let bookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
            
            weakSelf.outputBookmarkList.value = bookmarkList
        }
        
        inputForCollectionViewUpdateWithsearchText.bind { [weak self] searchText in
            guard let weakSelf = self else { return }

            let bookmarkList: [Bookmark] =  RealmManager.shared.read(Bookmark.self).map { $0 }
            
            weakSelf.outputBookmarkList.value = bookmarkList.filter { $0.title.contains(searchText) }
        }
        
        inputBookmarkIconButtonTapTrigger.bind { [weak self] bookmark in
            guard let weakSelf = self else { return }

            guard let bookmark = bookmark else { return }
            
            RealmManager.shared.delete(bookmark)
            
            let updatedBookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
            weakSelf.outputBookmarkList.value = updatedBookmarkList
        }
    }
}
