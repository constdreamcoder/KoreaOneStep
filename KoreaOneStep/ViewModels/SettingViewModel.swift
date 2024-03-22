//
//  SettingViewModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/20/24.
//

import Foundation

final class SettingViewModel {
    
    let inputBookmarkRemoveAllCellTapTrigger: Observable<Void?> = Observable(nil)
    
    let outputRemoveAllBookmarksToastMessage: Observable<String?> = Observable(nil)
    
    init() {
        inputBookmarkRemoveAllCellTapTrigger.bind { [weak self] trigger in
            guard let weakSelf = self else { return }
            
            guard let trigger = trigger else { return }
            
            let bookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
            
            if bookmarkList.count >= 1 {
                let toastMessage = RealmManager.shared.deleteAll()
                weakSelf.outputRemoveAllBookmarksToastMessage.value = toastMessage
                return
            }
            
            weakSelf.outputRemoveAllBookmarksToastMessage.value = nil
        }
    }
}
