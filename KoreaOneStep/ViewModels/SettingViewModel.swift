//
//  SettingViewModel2.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 8/17/24.
//

import Foundation
import RxSwift
import RxCocoa

typealias SettingTableViewCellTapType = (ControlEvent<SettingTableViewCellTitle>.Element, ControlEvent<IndexPath>.Element)

final class SettingViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input { 
        let itemTapped: Observable<SettingTableViewCellTapType>
    }
    
    struct Output {
        let settingTableViewCellTitles: Driver<[SettingTableViewCellTitle]>
        let removeAllBookmarksToastMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let removeAllBookmarksToastMessage = PublishRelay<String>()
        
        input.itemTapped
            .bind { _ in
                let bookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
                
                if bookmarkList.count >= 1 {
                    let toastMessage = RealmManager.shared.deleteAll()
                    removeAllBookmarksToastMessage.accept(toastMessage)
                    return
                }
                removeAllBookmarksToastMessage.accept(ToastMessage.Failure.noBookmarkContents)
            }
            .disposed(by: disposeBag)
           
        return Output(
            settingTableViewCellTitles: Observable.just(SettingTableViewCellTitle.allCases).asDriver(onErrorJustReturn: []), 
            removeAllBookmarksToastMessage: removeAllBookmarksToastMessage.asDriver(onErrorJustReturn: "")
        )
    }
}
