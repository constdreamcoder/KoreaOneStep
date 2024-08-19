//
//  BookmarkViewModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BookmarkViewModel: ViewModelType {
    
    let bookmarkIconButtonTapped = PublishSubject<Bookmark>()
    
    private let searchTextSubject = BehaviorSubject<String>(value: "")

    var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let searchText: ControlProperty<String>
        let textDidBeginEditing: Observable<Void>
    }
    
    struct Output {
        let viewWillAppear: Driver<Int>
        let section: Driver<[BookmarkSectionData]>
    }
    
    func transform(input: Input) -> Output {
        let sectionRelay = PublishRelay<[BookmarkSectionData]>()
        
        let viewWillAppear = input.viewWillAppear
            .map { trigger in
                let bookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
                sectionRelay.accept([BookmarkSectionData(items: bookmarkList)])
                return bookmarkList.count
            }
        
        input.searchText
            .subscribe(with: self) { owner, searchText in
                owner.searchTextSubject.onNext(searchText)
                owner.collectionViewUpdate(with: searchText, sectionRelay: sectionRelay)
            }
            .disposed(by: disposeBag)
        
        input.textDidBeginEditing
            .withLatestFrom(searchTextSubject)
            .subscribe(with: self) { owner, searchText in
                owner.collectionViewUpdate(with: searchText, sectionRelay: sectionRelay)
            }
            .disposed(by: disposeBag)
        
        bookmarkIconButtonTapped
            .bind { bookmark in
                RealmManager.shared.delete(bookmark)
                
                let updatedBookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
                sectionRelay.accept([BookmarkSectionData(items: updatedBookmarkList)])
            }
            .disposed(by: disposeBag)
        
        return Output(
            viewWillAppear: viewWillAppear.asDriver(onErrorJustReturn: 0),
            section: sectionRelay.asDriver(onErrorJustReturn: [])
        )
    }
}

// MARK: - Custom Methods
private extension BookmarkViewModel {
     func collectionViewUpdate(with searchText: String, sectionRelay: PublishRelay<[BookmarkSectionData]>) {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if searchText.isEmpty {
            let bookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
            sectionRelay.accept([BookmarkSectionData(items: bookmarkList)])
        } else {
            let bookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
            let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let filteredBookmarkList = bookmarkList.filter { $0.title.contains(trimmedSearchText) }
            sectionRelay.accept([BookmarkSectionData(items: filteredBookmarkList)])
        }
    }
}
