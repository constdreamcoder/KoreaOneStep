//
//  SettingViewModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/20/24.
//

import Foundation

final class SettingViewModel {
    
    let inputBookmarkRemoveAllCellTapTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        inputBookmarkRemoveAllCellTapTrigger.bind { trigger in
            guard let trigger = trigger else { return }
            
            RealmManager.shared.deleteAll()
        }
    }
}
